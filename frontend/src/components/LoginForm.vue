<template>
  <div class="LoginForm">
    <input id="email" type="email" :value="email" />
    <input id="password" type="password" :value="password" />
  </div>
</template>

<script>
export default {
  name: "LoginForm",
  props: {
    email: String,
    password: String,
  },
  mounted() {
    this.email;
    this.password;
  },
};
</script>
