// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.17;
pragma solidity ^0.5.16;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    struct airlineStructType {                                          
        string name;                
        bool isFunded;                                                         
        bool isAccepted;                                                        
        uint256 ID;                                                             
    }

    mapping(address => airlineStructType) private airlines;

    uint256 airlineCount;
    
    
    mapping(bytes32 => address[]) private insureesPerFlight;      
    

    struct passengerStructType{
        mapping (bytes32 => uint256) payOutAmount;          //byes32 maps/refers to id of flightID
        uint256 credit;
    }
    mapping(address => passengerStructType) private passengers;                 

    struct flightStructType {
        uint8 statusCode;
        uint256 timeStamp;     
    }

    mapping (bytes32 => flightStructType) private flights;     //flightID {name: "AC8617", "AC061", "OZ106"},
      
    address private contractOwner;                   // Initial deployment account
    
    mapping (address => bool) authorizedContracts;   // Authorized owner

    bool private operational = true;       // Operational status

    uint constant M=2;                         //Votng param
    address[] multiCalls = new address[](0);        //Check voting address

    uint256 airlineToVoteFor = 0;                // Check 
    address[] multiCallsAirlineVote = new address[](0);  //used for M and N



    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/
    event AirlineRegistered(address appUserAddress, address airlineAddress, string name, uint256 airlineCount);
    event AirlineVoteCasted(uint256 voteNumber, address airlineToVoteFor);
    event SuccessfulAirlineVoteCasted(uint256 voteNumber, uint256 voteHurdle, address airlineToVoteFor);
    event CreditPaidOut(address _passenger, uint256 creditPaidOut);
    event PayOutCredited(address _insuree, uint256 payOutAmount);
    event FlightProcessed(string flight, uint8 statusCode);
    event InsureesToFund(address[] insurees);
     

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor() public {
        contractOwner = msg.sender;
        airlines[msg.sender].name = "Contract owner Airways";
        airlines[msg.sender].isFunded = true;
        airlines[msg.sender].isAccepted = true;
        airlines[msg.sender].ID=1;
        airlineCount = 1;

        authorizedContracts[msg.sender] = true;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

        // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" 
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  
    }

    /**
    * @dev Modifier that requires the "ContractOwner" 
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireCallerAuthorized()
    {
      
        require(authorizedContracts[msg.sender], string(abi.encodePacked(msg.sender," not valid ")));
        _;
    }
    

  
  

   
    /********************************************************************************************/
    /*                                 REFERENCE DATA APP CONTRACT  FUNCTIONS                   */
    /********************************************************************************************/
     
    function authorizeCaller(address appContract) 
                                                    public 
                                                    requireContractOwner 
    {
        require(authorizedContracts[appContract] != true, "Authorized sender");
        authorizedContracts[appContract] = true;
    } 

    function deauthorizeCaller(address appContract) 
                                                    public 
                                                    requireContractOwner {
        delete authorizedContracts[appContract];
    } 
    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 

    {
        return operational;
    }

  function isAirline(address _address) external view returns(bool)
    {
        bool _isAirline;
        if (airlines[_address].ID != 0) {
            _isAirline = true;
        }  else {
            _isAirline = false;
        }
        return(_isAirline);

    }
    /**
    * @dev Sets contract operations on/off
    */    
    function setOperatingStatus
                            (
                                bool mode,
                                address appUserAddress
                            ) 
                            external
                            requireCallerAuthorized                         
    {

        require(isVotingAirline(appUserAddress), "Not funded ");
        require(mode != operational, "Change criteria");
        bool isDuplicate = false;
        for(uint c=0; c<multiCalls.length; c++) {
            if (multiCalls[c] == appUserAddress) {
                isDuplicate = true;
                break;
            }
        }
        require(!isDuplicate, "Previously called function.");

        multiCalls.push(appUserAddress);
        if (multiCalls.length >= M) {
            operational = mode;      
            multiCalls = new address[](0);      

    }

    }
    function getFlightID(string memory _flightName) pure internal returns(bytes32) {
        return keccak256(abi.encodePacked(_flightName));
    }

    function getBalance(address _passenger) external view returns (uint256) {
        return(passengers[_passenger].credit);
    }


         /**
    * @dev Function to retrieve airlinedata 
    *      
    */
    function isFundedAirline(address _address) public view returns(bool)
    {
        require(airlines[_address].ID != 0, "Airline not found.");
        return(airlines[_address].isFunded);  
    }
    function isAcceptedAirline(address _address) public view returns(bool)
    {
        require(airlines[_address].ID != 0, "Airline not found.");
        return(airlines[_address].isAccepted);  
    }


    function getPayOutAmount(address passengerAddress, string memory flightName) public view returns(uint256)
    {
        bytes32 flightID = getFlightID(flightName);
        uint256 _payOutAmount = passengers[passengerAddress].payOutAmount[flightID];
        return(_payOutAmount);
    }


  function isVotingAirline(address _address) public view returns(bool)
    {
        bool _isVotingAirline; 
        _isVotingAirline = false;
        if (        (airlines[_address].ID != 0) && 
                    (airlines[_address].isFunded) && 
                    (airlines[_address].isAccepted)) {
                      _isVotingAirline = true;  
                    }
        return(_isVotingAirline);  
    }


    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *  ADD without M & N 
    */   
    function registerAirline
                            (
                                address appUserAddress,
                                address airlineAddress,
                                string memory name
                            )
                            public
                            requireCallerAuthorized

    {   
        require(airlines[airlineAddress].ID==0, "Tis is a  registered airline and no need to register.");
        require((airlineToVoteFor==0) ||
                (airlineCount<=3)        , "Incomplete process ");
        
        airlineCount = airlineCount.add(1);
        airlines[airlineAddress].ID = airlineCount;
        airlines[airlineAddress].name = name;
        airlines[airlineAddress].isFunded = false;
        
        //Less than 4 is accepted and beyond that status set to false
        if (airlineCount<=4) {
            
            airlines[airlineAddress].isAccepted = true;
        } else {
            airlines[airlineAddress].isAccepted = false;

            
            // Opening  vote for this airline
            airlineToVoteFor = airlineCount;
        }
        emit AirlineRegistered(appUserAddress, airlineAddress, name, airlineCount);
    }
    /**
    * @dev Sets contract operations on/off
    * 50% voted to add
    */    
    function voteAirlineIn
                            (
                                address airlineCastedVoteFor,
                                address appUserAddress
                            ) 
                            external
                            requireCallerAuthorized                         
    {

        require(isVotingAirline(appUserAddress), "Caller is not funded and registered airline");
        require(airlines[airlineCastedVoteFor].ID == airlineToVoteFor, "Vote casted for the wrong airline");
        bool isDuplicate = false;
        for(uint c=0; c<multiCallsAirlineVote.length; c++) {
            if (multiCallsAirlineVote[c] == appUserAddress) {
                isDuplicate = true;
                break;
            }
        }
        require(!isDuplicate, "Caller has already called this function.");

        multiCallsAirlineVote.push(appUserAddress);
        uint256 hurdle = airlineCount.sub(1).div(2);
        if (multiCallsAirlineVote.length >= hurdle) {
            // Airline is accepted
            airlines[airlineCastedVoteFor].isAccepted = true;


            emit SuccessfulAirlineVoteCasted(multiCallsAirlineVote.length, hurdle, airlineCastedVoteFor);

            //Airlinevote is reset
            airlineToVoteFor = 0;      
            multiCallsAirlineVote = new address[](0);      
        } else {
            emit AirlineVoteCasted(multiCallsAirlineVote.length, airlineCastedVoteFor);
        }
    }
    /**
    * @dev Sets contract operations on/off
    *
    * reset vote 
    */    
    function resetAirlineVote
                            (
                            ) 
                            external
                            requireCallerAuthorized
                            requireContractOwner


    {
            airlineToVoteFor = 0;
            multiCallsAirlineVote = new address[](0);      
    }

   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buyInsurance
                            (         
                                address passengerAddress,
                                bytes32 flightID,
                                uint256 addPayOutAmount

                            )
                            external
                            payable
                            requireCallerAuthorized
                            requireIsOperational
    {
        
        uint256 beginPayOutAmount = passengers[passengerAddress].payOutAmount[flightID];
        passengers[passengerAddress].payOutAmount[flightID] = beginPayOutAmount.add(addPayOutAmount);

        insureesPerFlight[flightID].push(passengerAddress);  
    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                    bytes32 flightID
                                )
                                external
                                requireCallerAuthorized
                                requireIsOperational
    {   // Debit before credit
        address[] memory insurees = insureesPerFlight[flightID];
 
        emit InsureesToFund(insurees);
        
        //Loop through index of insurees per flight
        for (uint256 i = 0; i < insurees.length; i++) {
            address insuree = insurees[i];
            //Debit before Credit
            uint256 _payOutAmount = passengers[insuree].payOutAmount[flightID];
            passengers[insuree].payOutAmount[flightID] = 0;

            
            //Credit PayOutAmount to Balance/credit
            passengers[insuree].credit = passengers[insuree].credit.add(_payOutAmount); 
            emit PayOutCredited(insuree,_payOutAmount);      
        }

        
    }
    

    /**
     *  @dev Transfers  funds 
     *
    */
    function withdraw       (
                                address _passenger
                            )
                            public
                            payable
                            requireCallerAuthorized
    {
        require(_passenger == tx.origin, "Withdraw request must originate from passenger itself.");
        require(passengers[_passenger].credit > 0, "No pay out amounts allocated to passenger.");
        //Debit before credit
        uint256 credit = passengers[_passenger].credit;
        passengers[_passenger].credit = 0;
        


       address addr = _passenger; 
       address payable addrPay = address(uint160(addr));

      
       bool sent = addrPay.send(credit);
        
        require(sent, "Failed to send Ether");

        emit CreditPaidOut(_passenger, credit);

    }

   /**
    * @dev  fund insurance. 
    *      
    *
    */   
    function fundAirline
                            (
                                address airline
                            )
                            public
                            payable
                            requireCallerAuthorized
                            requireIsOperational
    {
        
        require(airlines[airline].ID != 0, "First register airline first.");
        // Avoid double funding
        require(airlines[airline].isFunded=true,"airline  funded.");
        
        airlines[airline].isFunded = true;
        

    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */

  

    function() 
                            external 
                            payable 
    {
        
    }


}