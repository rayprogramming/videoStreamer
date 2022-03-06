<template>
  <amplify-authenticator username-alias="email">
     <img alt="Vue logo" src="./assets/logo.png">
     <HelloWorld msg="You Successfully Authenticated a User!  Go You!"/>
     <amplify-sign-out></amplify-sign-out>
 </amplify-authenticator>
</template>

<script>
export default {
  name: "LoginForm",
  props: {},
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss"></style>
