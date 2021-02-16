<template>
  <div class="header">
    <div class="header-object-container">
      <router-link class="text-dark" :to="{ path: '/' }">
        <el-avatar> Kero </el-avatar>
      </router-link>
    </div>
    <div class="header-object-container">
      <el-avatar
        src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
      ></el-avatar
      >{{ $store.getters.currentAddress.substr(0, 7) }}...{{
        $store.getters.currentAddress.substring(37)
      }}
    </div>
    <div class="header-object-container">
      <el-alert
        :closable="false"
        show-icon
        title="Total Activities"
        type="info"
        :description="totalActivity"
      >
      </el-alert>
    </div>
    <div class="header-object-container">
      <router-link tag="button" class="el-button" :to="{ path: '/create' }">
        Create
      </router-link>
      <el-button :loading="connecting" type="primary" @click="connectWallet"
        >Connect Wallet
      </el-button>
    </div>
  </div>
</template>

<script>
import store from "@/store/index";
export default {
  name: "Header",
  data: function() {
    return {
      connecting: false,
      totalActivity: null
    };
  },
  methods: {
    connectWallet() {
      // TODO: check here https://docs.metamask.io/guide/ethereum-provider.html#basic-usage
      try {
        this.connecting = true;
        window.ethereum.request({ method: "eth_requestAccounts" });
      } catch (error) {
        console.error(error);
      }
      this.connecting = false;
    }
  },
  mounted() {
    let that = this;
    window.ethereum.on("accountsChanged", function(accounts) {
      console.log(accounts[0]);
    });
    const temp = store.getters
      .contract()
      .methods.getTotalActivity()
      .call();
    temp.then(function(val) {
      that.totalActivity = val;
    });
  }
};
</script>

<style scoped>
.header {
  display: flex;
  padding: 24px;
}
.header-object-container {
  flex: 1;
  margin: 5px;
}
</style>
