import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import "./plugins/element.js";
import web3 from "web3";

Vue.config.productionTip = false;

Vue.filter("toWei", key => {
  return web3.utils.toWei(key, "ether");
});

(async () => {
  try {
    await store.dispatch("getContractInstance");
    await store.dispatch("registerWeb3");
  } catch (e) {
    console.log("error while initializing store", e);
  } finally {
    new Vue({
      router,
      store,
      render: function(h) {
        return h(App);
      }
    }).$mount("#app");
  }
})();
