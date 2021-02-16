<template>
  <div id="app">
    <header-comp></header-comp>
    <router-view class="router-view"></router-view>
    <footer-comp></footer-comp>
  </div>
</template>

<script>
import Header from "./components/Header";
import Footer from "./components/Footer";

export default {
  name: "app",
  components: {
    "footer-comp": Footer,
    "header-comp": Header
  }
};
</script>

<style>
#app {
  font-family: "Ubuntu", Helvetica, Arial, sans-serif;
}
.router-view {
  margin-bottom: 100px;
}
</style>
