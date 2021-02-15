<template>
  <div class="card-body">
    <router-link
      class="text-dark"
      :to="{ path: '/activity/' + activity.address }"
    >
      <img
        class="card-img img-fluid rounded mx-auto d-block"
        :src="getImageUrl()"
        alt="Card image"
        style="max-width: 100%; height: 75%"
      />
      <div class="card-body">
        <h6 class="card-title">{{ activity.name.toUpperCase() }}</h6>
        <p class="card-text">{{ activity.content }}</p>
      </div>
    </router-link>
  </div>
</template>

<script>
export default {
  name: "Activity",
  data: function() {
    return {
      activity: {
        address: "asd",
        name: "asdasd",
        content: "asdasd"
      }
    };
  },
  methods: {
    getImageUrl: function() {
      return "https://picsum.photos/200";
    }
  }
};
</script>

<style scoped></style>
