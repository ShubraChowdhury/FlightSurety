var HDWalletProvider = require('@truffle/hdwallet-provider');
var mnemonic = "away rib room fever setup cruise organ blush upon apology soda copper";

module.exports = {
  networks: {
    development: {

      
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      
     
      /*
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:7545/", 0, 50);
      },
      network_id: '*',
      gas: 6721975
      */
     
      
    }
  },
  compilers: { 
    solc: {
      version: "^0.5.16"
    } 
  }
};
