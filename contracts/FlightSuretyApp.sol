// SPDX-License-Identifier: MIT
//pragma solidity ^0.4.24;
//pragma solidity ^0.8.17;
pragma solidity ^0.5.16;


// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

//import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./FlightSuretyData.sol";


/************************************************** */
/* FlightSurety Smart Contract                      */
/************************************************** */
contract FlightSuretyApp {
    using SafeMath for uint256; 

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    address private contractOwner;    // Initial contract owner

    //Reference to FlightSuretyData 
    FlightSuretyData private flightSuretyData;

    //Funding requirement set in app contract and handed over into data contract
    //Risk assessment: because airline needs to be voted in (set in data contract) risk of being manipulated on way to data contract with low relevance
    uint256 airlineFundingRequirement = 10000000000000000000;

    uint256 payOutMultiple = 150;  
    uint256 maxInsurancePayOut = payOutMultiple.mul(1000000000000000000).div(100); 
    
    struct flightStructType {
        string flightName;
        bool isRegistered;
        uint8 statusCode;
        uint256 updatedTimestamp;        
        address airline;
    }
    mapping(bytes32 => flightStructType) private flights;

    event FlightProcessed(string _flight, uint8 statusCode);
    event OracleRegistered(address oracleAddress);

 
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
    
        require(true, "Contract is currently not operational");  
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

    

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    /**
    * @dev Contract constructor
    *
    */
    constructor(address dataContract)  public
    {
        contractOwner = msg.sender;

        address addr = dataContract;
        address payable addrPay = address(uint160(addr)); // converting address to payable address

        flightSuretyData = FlightSuretyData(addrPay);
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() 
                            public 
                            pure 
                            returns(bool) 
    {
        return true;  
    }
    function getFlightID(string memory _flightName) pure internal returns(bytes32) {
        return keccak256(abi.encodePacked(_flightName));
    }
    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/



   /**
    * @dev Register flight.
    *
    */  
    function registerFlight
                                (
                                    string calldata flightName     
                                )
                                external
                                requireIsOperational
    {
        require(flightSuretyData.isVotingAirline(msg.sender),"Airline is not yet fully funded and voted in.");
        bytes32 _flightID = getFlightID(flightName);
        require(!flights[_flightID].isRegistered,"Flight already registered");

        // flights[_flightID].flightID = _flightID;
         
        flights[_flightID].isRegistered = true;
        flights[_flightID].flightName = flightName;
        flights[_flightID].statusCode = STATUS_CODE_UNKNOWN;
        flights[_flightID].airline = msg.sender;
    
    }

    /**
    * @dev Get  flight information.
    *
    */  

    function getFlightInfo
                                (
                                    string calldata flightName
                                )
                                external
                                view
                                returns (bool, uint8, uint256, address)
    {
        bytes32 _flightID = getFlightID(flightName);
        require(flights[_flightID].isRegistered,"Flight not yet registered");
        return(
            flights[_flightID].isRegistered,
            flights[_flightID].statusCode,
            flights[_flightID].updatedTimestamp,
            flights[_flightID].airline);
          

            
    
    }


    
   /**
    * @dev process flight status
    *
    */  
    function processFlightStatus
                                (
                                    string memory flight,
                                    uint256 timestamp,
                                    uint8 statusCode
                                )
                                internal
                                requireIsOperational
    {
        bytes32 flightID = getFlightID(flight);
        flights[flightID].statusCode = statusCode;
        flights[flightID].updatedTimestamp = timestamp;
         
        if (statusCode == STATUS_CODE_LATE_AIRLINE) {

            flightSuretyData.creditInsurees(flightID);
        }
        emit FlightProcessed(flight, statusCode);
    }


    //  fetch flight status
    function fetchFlightStatus
                        (
                            address airline,
                            string calldata flight,
                            uint256 timestamp                            
                        )
                        external
    {
        uint8 index = getRandomIndex(msg.sender);

        // Generate a unique key for storing the request
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp));
        
        ResponseInfo storage responseInfo = oracleResponses[key];
        responseInfo.requester = msg.sender;
        responseInfo.isOpen = true;
        emit OracleRequest(index, airline, flight, timestamp);
    } 
    function registerAirlineApp(
                                address airlineAddress,
                                string memory name
                            )
                            public
    {
        flightSuretyData.registerAirline(msg.sender, airlineAddress, name);
    }

    function setOperatingStatusApp
                        (
                            bool mode
                            
                        ) 
                        external   
    {
        flightSuretyData.setOperatingStatus(mode, msg.sender);
    }    
    function isOperationalApp() 
                            public 
                            view 
                            returns(bool) 
                            
    {
        return(flightSuretyData.isOperational());
    }

    function voteAirlineInApp
                            (
                                address airlineCastedVoteFor
                            ) 
                            external       
    {
        flightSuretyData.voteAirlineIn(airlineCastedVoteFor, msg.sender);   
    }

    function fundAirlineApp
                            (
                                address airline
                            )
                            public
                            payable
    {
        // Airline must be registered first
        require(msg.value >= airlineFundingRequirement, "Not sufficient funds sent");

        
        flightSuretyData.fundAirline(airline);

    }

    function buyInsuranceApp
                            (         
                                string calldata flightName

                            )
                            external
                            payable
    {
        bytes32 _flightID = getFlightID(flightName);
        require(flights[_flightID].isRegistered,"Flight not yet registered");
        uint256 alreadyPaidIn = flightSuretyData.getPayOutAmount(msg.sender, flightName);
        uint256 addPayOut = msg.value.mul(payOutMultiple).div(100);
        require(alreadyPaidIn.add(addPayOut) <= maxInsurancePayOut, "Additional insurance leads to overinsurance");
        flightSuretyData.buyInsurance(msg.sender, _flightID, addPayOut);
    }
    
    function withdrawApp       (
                                )
                                public
                                requireIsOperational
    {
        flightSuretyData.withdraw(msg.sender);
    }
// region ORACLE MANAGEMENT

    // BlockChain nonce
    uint8 private nonce = 0;    

    // REGISTRATION Fee 
    uint256 public constant REGISTRATION_FEE = 1 ether;

    // Min resp 
    uint256 private constant MIN_RESPONSES = 3;


    struct Oracle {
        bool isRegistered;
        uint8[3] indexes;        
    }

    
    struct ResponseInfo {
        address requester;                              
        bool isOpen;                                   
        mapping(uint8 => address[]) responses;         
                                                        
                                                        
    }
 
    mapping(address => Oracle) private oracles;
    mapping(bytes32 => ResponseInfo) private oracleResponses;


    event FlightStatusInfo(address airline, string flight, uint256 timestamp, uint8 status);
    event OracleReport(address airline, string flight, uint256 timestamp, uint8 status);
    event OracleRequest(uint8 index, address airline, string flight, uint256 timestamp);


    // Register oracle 
    function registerOracle
                            (
                            )
                            external
                            payable
    {
  
        require(msg.value >= REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateIndexes(msg.sender);

        oracles[msg.sender] = Oracle({
                                        isRegistered: true,
                                        indexes: indexes
                                    });
        emit OracleRegistered(msg.sender);
    }
    function registerMultipleOracles
                                    (
                                        address[] calldata oracleAddresses
                                    )
                                    external
                                    payable
    {
        uint256 valuePerOracle = msg.value.div(oracleAddresses.length);
        require(valuePerOracle>= REGISTRATION_FEE, "Registration fee is not sufficient");
        for (uint i=0; i<oracleAddresses.length; i++) {
            uint8[3] memory indexes = generateIndexes(oracleAddresses[i]);

            oracles[oracleAddresses[i]] = Oracle({
                                        isRegistered: true,
                                        indexes: indexes
                                    });
            emit OracleRegistered(oracleAddresses[i]);
        } 
    }
    function getMyIndexes
                            (
                            )
                            view
                            external
                            returns(uint8[3] memory)
    {
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }

    
    function submitOracleResponse
                        (
                            uint8 index,
                            address airline,
                            string calldata flight,
                            uint256 timestamp,
                            uint8 statusCode
                        )
                        external
    {
        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");


        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp)); 
        require(oracleResponses[key].isOpen, "Flight or timestamp do not match oracle request");

        oracleResponses[key].responses[statusCode].push(msg.sender);
    
        emit OracleReport(airline, flight, timestamp, statusCode);
        if (oracleResponses[key].responses[statusCode].length >= MIN_RESPONSES) {
            emit FlightStatusInfo(airline, flight, timestamp, statusCode);
            processFlightStatus(flight, timestamp, statusCode);
        }
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

    // Generate index
    function generateIndexes
                            (                       
                                address account         
                            )
                            internal
                            returns(uint8[3] memory)
    {
        uint8[3] memory indexes;
        indexes[0] = getRandomIndex(account);
        
        indexes[1] = indexes[0];
        while(indexes[1] == indexes[0]) {
            indexes[1] = getRandomIndex(account);
        }

        indexes[2] = indexes[1];
        while((indexes[2] == indexes[0]) || (indexes[2] == indexes[1])) {
            indexes[2] = getRandomIndex(account);
        }

        return indexes;
    }

    // randon number
    function getRandomIndex
                            (
                                address account
                            )
                            internal
                            returns (uint8)
    {
        uint8 maxValue = 10;
        uint8 random = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - nonce++), account))) % maxValue);

        if (nonce > 250) {
            nonce = 0;  
        }

        return random;
    }

// endregion

}   