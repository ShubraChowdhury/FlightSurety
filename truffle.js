var HDWalletProvider = require('@truffle/hdwallet-provider');
var mnemonic = "supreme primary proof duck fortune subject mean wonder hockey ceiling peace change";

module.exports = {
  networks: {
    development: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:7545/", 0, 50);
      },
      network_id: '*',
      
    }
  },
  compilers: {
    solc: {
      version: "^0.4.24"
    }
  }
};