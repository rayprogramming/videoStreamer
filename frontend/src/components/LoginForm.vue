<template>
  <div class="login">
    <form action="/login" method="post">
      <input type="email" name="email" id="email" value="" />
      <input type="password" name="password" id="password" value="" />
    </form>
  </div>
</template>

<script>
export default {
  name: "LoginForm",
  props: {
    email: String,
    password: String
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss"></style>
