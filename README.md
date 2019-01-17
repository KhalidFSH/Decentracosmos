[![Udacity - Blockchain Developer Nanodegree](https://bit.ly/2svzNOI)](https://www.udacity.com/blockchain)

# Decentracosmos

[![solid](https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/155/milky-way_1f30c.png)](https://decentracosmos-jxazhqilpk.now.sh/)

Imaginary cosmos, whiche can produce endless of gallaxies contain a randome genrated number of stars in randome system as ERC721 Non-Fungible Tokens, can be traded between users, also who knows maybe some day will change the sky to an augmented one and you can blow up yours in beautiful day.
 
Smart contracts built in Solidity v0.5.0 with the power of inhertens, and deployed using Truffle in Ethereum Rinkiby  testnet.
Dapp (web frontend) built using React and web3 to connect to the blockchain network.
[Live Demo(running in Rinkeby testnet)](https://decentracosmos-jxazhqilpk.now.sh/) 

## ERC-721 Token Info
  - Name: `Decentracosmos`
  - Symbol: `MOS`
  - Contract Address: `0xc105551255aD2a1538C49C124AABc9bA60Bc48e8`

## Prerequisites

### Requires NPM
Homebrew on Mac OSX:
```sh
$ brew install node npm
```
Apt on Linux:
```sh
$ apt-get install node npm
```
### Install truffle globally
```sh
$ npm install truffle -g
```

## Installation
### Install the local NPM packages:
```sh
$ npm install
```
### Install DAPP NPM packages:
```sh
$ cd dapp
$ npm install
```

## Run
### Enter and run Truffle develope console (local blockchain)
```sh
$ truffle develop
```
### Compile the Solidity code (inside development env)
```sh
truffle(develop)> compile
```
### Testing 
```sh
truffle(develop)> test
```
### Migrate to local testnet
```sh
truffle(develop)> migrate
```
### Start the server
Make sure the truffle contracts are compiled and migrated, and ganache is running.
```sh
$ cd dapp
$ npm run start
```

## Directory Tree
```
> .
├── LICENSE.md
├── README.md
├── contracts
│   ├── StarNotary.sol
│   ├── erc721_superpower
│   │   ├── Exchangable.sol
│   │   └── Salable.sol
│   ├── univarse
│   │   ├── Cosmos.sol
│   │   ├── Galaxies.sol
│   │   └── Stars.sol
│   └── utils
│       └── Migrations.sol
├── dapp
│   ├── README.md
│   ├── package.json
│   ├── public
│   │   ├── favicon.ico
│   │   ├── index.html
│   │   └── manifest.json
│   └── src
│       ├── App.css
│       ├── App.js
│       ├── App.test.js
│       ├── index.css
│       ├── index.js
│       ├── serviceWorker.js
│       └── utils
│           └── getWeb3.js
├── migrations
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── package.json
├── test
│   └── star-notary.js
└── truffle-config.js

10 directories, 26 files
```

## Built with ❤️ using:
* [**Solidity**](https://solidity.readthedocs.io/en/v0.5.0/) -  An object-oriented, high-level language for implementing smart contracts. 
* [**OpenZeppelin**](https://openzeppelin.org/) -  A library for secure smart contract development. It provides implementations of standards like ERC20 and ERC721.
* [**Truffle**](https://truffleframework.com/) -  A world class development environment, testing framework and asset pipeline for blockchains using the Ethereum Virtual Machine (EVM).
* [**React**](https://reactjs.org/) -  A JavaScript library for building user interfaces.
* [**reactstrap**](https://hapijs.com) -  Easy to use React Bootstrap 4 components.


## Author


* **Khalid F.SH**  - [Email](dev.khalid@me.com)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
