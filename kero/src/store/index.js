import Vue from "vue";
import Vuex from "vuex";
import { getWeb3, getContract } from "../common/web3Service";

Vue.use(Vuex);

export default new Vuex.Store({
  strict: true, // don't leave it true on production
  state: {
    web3: {
      isInjected: false,
      web3Instance: null,
      networkId: null,
      coinbase: null,
      balance: null,
      error: null
    },
    contractInstance: null,
    NETWORKS: {
      "1": "Binance Chain",
      "2": "Binance Smart chain",
      "3": "Ethereum",
      "4": "Binance Chain Test",
      "42": "Binance Smart Chan Test",
      "4447": "Truffle Develop Network",
      "5777": "Ganache Blockchain"
    }
  },
  mutations: {
    registerWeb3Instance(state, payload) {
      console.log("registerWeb3instance Mutation being executed ", payload);
      let result = payload;
      state.web3.isInjected = result.injectedWeb3;
      state.web3.web3Instance = result.web3;
      state.web3.coinbase = result.coinbase[0];
    },
    registerContractInstance(state, payload) {
      console.log("registerContractInstance mutation being executed ", payload);
      state.contractInstance = () => payload;
    }
  },
  actions: {
    registerWeb3({ commit }) {
      getWeb3
        .then(result => {
          console.log(
            "committing result to registerWeb3Instance mutation ",
            result
          );
          commit("registerWeb3Instance", result);
        })
        .catch(e => {
          console.log("Error in getWeb3 ", e);
        });
    },
    getContractInstance({ commit }) {
      getContract
        .then(result => {
          console.log(
            "committing result to registerContractInstance mutation ",
            result
          );
          commit("registerContractInstance", result);
        })
        .catch(e => console.log("Error in getContract ", e));
    }
  },
  getters: {
    web3state: state => {
      return state.web3;
    },
    web3Instance: state => {
      return state.web3.web3Instance;
    },
    balance: state => {
      return (state.web3.balance / 1000000000000000000).toFixed(4);
    },
    currentAddress: state => {
      return state.web3.coinbase;
    },
    network: state => {
      return state.NETWORKS[state.web3.networkId];
    },
    contract: state => {
      return state.contractInstance;
    }
  }
});
