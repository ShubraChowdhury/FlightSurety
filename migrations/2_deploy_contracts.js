console.log("SHUBRA deployer 2");


const FlightSuretyApp = artifacts.require("FlightSuretyApp");
const FlightSuretyData = artifacts.require("FlightSuretyData");
const fs = require('fs');


module.exports = function(deployer) {

    console.log("SHUBRA deployer 2 STEP 2")

     let firstAirline = "0xEA598eFC5f657b7899259B9d18d2704C5aE25464";
     
    
    deployer.deploy(FlightSuretyData)
       .then(() => {
          return deployer.deploy(FlightSuretyApp,FlightSuretyData.address)
                .then(() => {
                    let config = {
                        localhost: {
                            url: 'http://localhost:7545',
                            dataAddress: FlightSuretyData.address,
                            appAddress: FlightSuretyApp.address,
                             ownerAddress: '0xd9464968486109A2d086198B1E0Ae68e6aeF792c',

                            startingAirlines: [
                                {name: "First Self Registered Airline", address: '0xd9464968486109A2d086198B1E0Ae68e6aeF792c'}, 
                                {name: "Air-1", address: '0x94E211b2F01B71B8B266803648a246EA59D6b9cF'}, 
                                {name: "Air-2", address: '0x2a3B4579796C6a63167b30585E084B3432D9c2BF'}, 
                                {name: "Air-3", address: '0x557f7235bf2Ae8F305d737Da6858398C1E51fAb2'} 
                            ],
                            startingFlights: [
                                {name: "AC8617", from: "IAD", to: "YYZ"},
                                {name: "AC061", from: "YYZ", to: "ICN"},
                                {name: "OZ106", from: "ICN", to: "NRT"}
                                 
                            ],

 
                            oracleAddresses:[
                            "0xEA598eFC5f657b7899259B9d18d2704C5aE25464",
                            "0xAa588B05a4F20D9cE674B2b562a0d9587523fB1A",
                            "0x94E211b2F01B71B8B266803648a246EA59D6b9cF",
                            "0x2a3B4579796C6a63167b30585E084B3432D9c2BF",
                            "0x557f7235bf2Ae8F305d737Da6858398C1E51fAb2",
                            "0xe569B443e5c346b347980C37Bb560F6484F19783",
                            "0x942255760EB5c14DF881901b13516bdbBE4Ce7e6",
                            "0xfD3cDE390D59F5A55EA2C4bb7829f369cA7EB131",
                            "0x822A84a86c9362CDeC3F3680d6C982D05AFe8Ce2",
                            "0x6a58F8A61890bE6746243fe039f92a0367164D1C",
                            "0x6Ec2f3cFb220Bc326E39852D621e499295066c70",
                            "0x2EA804e9C5fF1Fd06ddeE8bc02C00cA60a64540E",
                            "0x4afC1D74cf2290Fb3f32D33e6FfE6789f2351b23",
                            "0xa9A68c73c1cBDf2f0e97aFC311dfB6d99b55df78",
                            "0x03F0FbBC5B4075D9B26C44130bF8CAE934C0fF47",
                            "0x7AA011bd3d7898df3E44728A308649E10bFc168E",
                            "0xB4412564609397c0Ec5a1117899072160f657cd5",
                            "0x72EDB1ac6d8aD975781BE7348296f0b33E83359b",
                            "0xaD2609035bb98DF77aEeAF1e89f33A5e3687147b",
                            "0xb12f13970BbaE5b57C8fe3F87dF71C29fB0AB230",
                            "0x148fE2a87759E59860Eb4c48106CEA87d47cAa65",
                            "0x13cD886C27c6e7aD8e4026e40323e9f673B668D9",
                            "0x05faf2A5F49C3356d280d9EC92d4e88E5ceFeDad",
                            "0x15db00199393A7304617d37c665eDBAb807F1F74",
                            "0xDE7f0295c81F036565c97569Aea5178C4904f8A6",
                            "0x34818bDE99e51351A0436Aa538FE4DEd82f4c929",
                            "0x8Ae92178c5bDe95F1228fDc55AD3b7dC4059D4fE",
                            "0x57646DE78ecf85bD65F836f73d72E310e17D7003",
                            "0xA33dA458a23811F44265916086ae313f34f91D01"
                            ] 

                        }
                    }
                    console.log("DIR NAME =" +__dirname );
                    fs.writeFileSync(__dirname + '/../src/dapp/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
                    fs.writeFileSync(__dirname + '/../src/server/config.json',JSON.stringify(config, null, '\t'), 'utf-8');
                });
    });
}


