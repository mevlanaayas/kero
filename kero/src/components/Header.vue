<template>
  <div class="header">
    <div class="header-object-container">
      <el-avatar> Kero </el-avatar>
    </div>
    <div class="header-object-container">
      <el-avatar
        src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
      ></el-avatar
      >{{ $store.getters.currentAddress }}
    </div>
    <div class="header-object-container">
      <el-avatar> Activities </el-avatar>
      {{ totalActivity }}
      <router-link class="text-dark" :to="{ path: '/create' }">
        <div class="card-body">
          <h1 class="card-title">Create</h1>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
import store from "@/store/index";
export default {
  name: "Header",
  data: function() {
    return {
      totalActivity: null
    };
  },
  mounted() {
    const temp = store.getters
      .contract()
      .methods.getTotalActivity()
      .call();
    let that = this;
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
  text-align: center;
}
</style>
