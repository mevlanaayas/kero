const Web3 = require("web3");

import activityContract from "../../../build/contracts/ActivityContract.json";

const addrActivityContract = "0x8Fd617888c205df74CD90330c3A50D949F47499B";

// eslint-disable-next-line no-unused-vars
const NETWORKS = {
  "1": "Binance Chain",
  "2": "Binance Smart chain",
  "3": "Ethereum",
  "4": "Binance Chain Test",
  "42": "Binance Smart Chan Test"
};

// eslint-disable-next-line no-unused-vars
const getContract = new Promise(function(resolve, reject) {
  let contract;
  let web3Instance = new Web3(
    Web3.givenProvider ||
      new Web3.providers.HttpProvider("http://localhost:7545")
  );

  contract = new web3Instance.eth.Contract(
    activityContract.abi,
    addrActivityContract
  );

  resolve(contract);
});

// eslint-disable-next-line no-unused-vars
let getWeb3 = new Promise(function(resolve, reject) {
  let web3Instance = new Web3(
    Web3.givenProvider ||
      new Web3.providers.HttpProvider("http://localhost:7545")
  );

  resolve({
    injectedWeb3: typeof Web3.givenProvider === undefined,
    web3() {
      return web3Instance;
    }
  });
}).then(result => {
  return new Promise(function(resolve, reject) {
    // Retrieve coinbase
    result.web3().eth.getAccounts((err, coinbase) => {
      if (err) {
        reject(new Error("Unable to retrieve coinbase"));
      } else {
        result = Object.assign({}, result, { coinbase });
        resolve(result);
      }
    });
  });
});
export { getWeb3, getContract };
