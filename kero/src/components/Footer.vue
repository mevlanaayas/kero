<template>
  <footer class="spec-footer footer">
    <div class="row">
      <div>
        <p class="text-center">© {{ new Date().getFullYear() }} Kero</p>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: "Footer"
};
</script>

<style>
.spec-footer {
  right: 0;
  bottom: 0;
  left: 0;
  padding: 6px;
  background-color: #ff9e8b;
  color: white;
  text-align: center;
  position: fixed;
}
</style>
