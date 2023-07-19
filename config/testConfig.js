
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");

//var FlightSuretyApp = require("../contracts/FlightSuretyApp.sol");
//var FlightSuretyData = require("../contracts/FlightSuretyData.sol");
//var Test = require('../config/testConfig.js');

//console.log("SHUBRA Artifacts"+FlightSuretyApp.new());

var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
      let testAddresses = accounts;
    /* I can use it here or in deploy with more details */
   /* let testAddresses =
    [
        "0xAb20e4600cC0501a285ACDFcFa95D5E103453f1A",
        "0x583b3B15E368deBE2691042dcdd389832CD406c0",
        "0x0cEBD0b754Be1792eEb76a583F4aa18621b3cCAf",
        "0xC4A7fa56286924D02c0Acb9DBc52a214ae53ECCf",
        "0xD2B1f4F67a53Ac58fBA3Ca8537C4f7b7Baa9Aa7b",
        "0x170a75ca7eb7811Fcc2A025E3b431E66A6c8c57C",
        "0x991e4F6F3d3a8D84a237EB9Eb6882C425E1233fa",
        "0x58081334E6BbD41EB77c28A32bc132E7fB3800ae",
        "0xF84b79e263F18A5628940A56E803634f55Bc15fb",
        "0x7843B21aacf692050De631dACb6fE6d239cd3920",
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
        "0xA33dA458a23811F44265916086ae313f34f91D01",
        "0xd9464968486109A2d086198B1E0Ae68e6aeF792c"
         ];
      */
    

    let owner = accounts[0];
    //console.log("Owner = "+owner);
    let firstAirline = accounts[1];
    //console.log("firstAirline  = "+firstAirline );

    //console.log("testAddresses = "+testAddresses);

    //let flightSuretyData = await FlightSuretyData.new(firstAirline);
    let flightSuretyData = await FlightSuretyData.new();
    //console.log("flightSuretyData ="+flightSuretyData);


    let flightSuretyApp = await FlightSuretyApp.new(flightSuretyData.address);
    //console.log("flightSuretyAp= "+flightSuretyAp);



    
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


