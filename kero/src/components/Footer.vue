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
  margin-bottom: 0;
  right: 0;
  bottom: 0;
  left: 0;
  padding: 6px;
  background-color: Tomato;
  color: white;
  text-align: center;
  position: absolute;
}
</style>
