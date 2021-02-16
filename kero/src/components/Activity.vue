<template>
  <el-card shadow="hover" style="margin: 10px; display: flex !important;">
    <router-link
      class="text-dark"
      :to="{ path: '/activity/' + activity.address }"
    >
      <img :src="getImageUrl()" class="image" alt="" />
    </router-link>

    <div style="padding: 14px; float: right">
      <span>{{ activity.name.toUpperCase() }}</span>
      <div class="bottom clearfix">
        {{ activity.content }}
      </div>
    </div>
  </el-card>
</template>

<script>
export default {
  name: "Activity",
  props: {
    activity: Object
  },
  methods: {
    getImageUrl: function() {
      return "https://picsum.photos/200";
    }
  }
};
</script>

<style scoped></style>
