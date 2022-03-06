<template>
  <amplify-authenticator username-alias="email">
     <img alt="Vue logo" src="../assets/logo.png">
     <HelloWorld msg="You Successfully Authenticated a User!  Go You!"/>
     <amplify-sign-out></amplify-sign-out>
 </amplify-authenticator>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";

export default {
  name: "Home",
  components: {
    HelloWorld,
  },
};
</script>
