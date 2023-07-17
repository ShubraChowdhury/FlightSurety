const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');

//console.log("SHUBRA deployer 2")

module.exports = function(deployer,network, accounts) {

   // console.log("SHUBRA deployer 2 STEP 2")

   // let firstAirline = '0xf17f52151EbEF6C7334FAD080c5704D77216b732';
    let firstAirline =  '0x178fb49a921eeA9C00f2f93ec81f476d41227B59';
    //"0x869F67888baCddcF5a2869D55cf67767B6CD34c8"
    deployer.deploy(FlightSuretyData,firstAirline)
    //console.log("SHUBRA deployer 2 STEP 3")
    .then(() => {
        //console.log("SHUBRA deployer 2 STEP 3")
        return deployer.deploy(FlightSuretyApp,FlightSuretyData.address)
                .then(() => {
                    let config = {
                        localhost: {
                            url: 'http://localhost:7545',
                            dataAddress: FlightSuretyData.address,
                            appAddress: FlightSuretyApp.address
                        }
                    }
                    fs.writeFileSync(__dirname + '/../src/dapp/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
                    fs.writeFileSync(__dirname + '/../src/server/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
                });
    });
}