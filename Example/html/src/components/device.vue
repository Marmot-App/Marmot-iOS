<template>
<div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 2</btn></div>
    <div><btn v-on:click="greet" value="">add 3</btn></div>
    <div><btn v-on:click="greet" value="">add 4</btn></div>
    <div><btn v-on:click="greet" value="">add 5</btn></div>
    <div><btn v-on:click="greet" value="">add 6</btn></div>
    <div><btn v-on:click="greet" value="">add 7</btn></div>
    <div><btn v-on:click="greet" value="">add 8</btn></div>
    <div><btn v-on:click="greet" value="">add 9</btn></div>
</div>
</template>

<script>
export default {
  name: "device",
  data() {
    return {
      msg: "Welcome to Your Vue.js App"
    };
  },
  methods: {
    greet: function(event) {
      JSBridge('sp://device/id').then((result) => {
        console.log(result);
      }).catch((err) => {
        console.log(err);
      });
    }
  }
};
</script>

<style scoped>
#btn {
  background-color: cadetblue;
  height: 20px;
}
</style>
