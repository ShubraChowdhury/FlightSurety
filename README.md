# FlightSurety

FlightSurety is a sample application project for Udacity's Blockchain course.

## Install

This repository contains Smart Contract code in Solidity (using Truffle), tests (also using Truffle), dApp scaffolding (using HTML, CSS and JS) and server app scaffolding.

To install, download or clone the repo, then:

`npm install`
`truffle compile`

## Develop Client

To run truffle tests:

`truffle test ./test/flightSurety.js`
`truffle test ./test/oracles.js`

To use the dapp:

`truffle migrate`

On local Machine before running dapp run the below mentioned
`export NODE_OPTIONS=--openssl-legacy-provider`
`npm run dapp`

To view dapp:

`http://localhost:8000`

## Develop 

On local Machine before running server run the below mentioned
`export NODE_OPTIONS=--openssl-legacy-provider`

`npm run server`
`truffle test ./test/oracles.js`

## Deploy

To build dapp for prod:
`npm run dapp:prod`

Deploy the contents of the ./dapp folder


## Resources

* [How does Ethereum work anyway?](https://medium.com/@preethikasireddy/how-does-ethereum-work-anyway-22d1df506369)
* [BIP39 Mnemonic Generator](https://iancoleman.io/bip39/)
* [Truffle Framework](http://truffleframework.com/)
* [Ganache Local Blockchain](http://truffleframework.com/ganache/)
* [Remix Solidity IDE](https://remix.ethereum.org/)
* [Solidity Language Reference](http://solidity.readthedocs.io/en/v0.4.24/)
* [Ethereum Blockchain Explorer](https://etherscan.io/)
* [Web3Js Reference](https://github.com/ethereum/wiki/wiki/JavaScript-API)


Reffered 
https://knowledge.udacity.com/questions/334014
https://knowledge.udacity.com/questions/540248
https://knowledge.udacity.com/?nanodegree=nd1309&page=1&project=564&query=payable&rubric=3609
https://knowledge.udacity.com/questions/996488
https://knowledge.udacity.com/questions/990715
https://knowledge.udacity.com/questions/986436