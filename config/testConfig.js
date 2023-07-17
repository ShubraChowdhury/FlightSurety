
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");
var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x178fb49a921eeA9C00f2f93ec81f476d41227B59",
        "0x15847802b8eE4008D2765c60cDD4a49FBB44a133",
        "0x178fb49a921eeA9C00f2f93ec81f476d41227B59",
        "0x869F67888baCddcF5a2869D55cf67767B6CD34c8",
        "0x9Daf72ea7fe875780ECD5CFaccF2C78e04606C96",
        "0xAb0D76F21eDD2de7Ce17364D7846A4aE45646a21",
        "0xcbd22ff1ded1423fbc24a7af2148745878800024",
        "0xc257274276a4e539741ca11b590b9447b26a8051",
        "0x2f2899d6d35b1a48a4fbdc93a37a72f264a9fca7"
    ];


    let owner = accounts[0];
    let firstAirline = accounts[1];

    let flightSuretyData = await FlightSuretyData.new();
    let flightSuretyApp = await FlightSuretyApp.new();

    
    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};