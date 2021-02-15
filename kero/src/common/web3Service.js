import Web3 from "web3";

import activityContract from "../../../build/contracts/ActivityContract.json";

const addrActivityContract = "0x22495aAA19e2e5578A0F3d5416DAbc4dd238e0A5";

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
  let web3 = window.web3;
  let contract;
  if (typeof web3 !== "undefined") {
    web3 = new Web3(web3.currentProvider);
    contract = new web3.eth.Contract(
      activityContract.abi,
      addrActivityContract
    );
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
    contract = new web3.eth.Contract(
      activityContract.abi,
      addrActivityContract
    );
  }

  resolve(contract);
});

// eslint-disable-next-line no-unused-vars
let getWeb3 = new Promise(function(resolve, reject) {
  const web3js = window.web3;
  if (typeof web3js !== "undefined") {
    var web3 = new Web3(web3js.currentProvider);
    resolve({
      injectedWeb3: true,
      web3() {
        return web3;
      }
    });
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545")); // If no injected web3 instance is detected, fallback to Ganache.
    resolve({
      injectedWeb3: false,
      web3() {
        return web3;
      }
    });
  }
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
