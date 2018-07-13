<template>
<div>
    <div><btn value="">"system"</btn></div>
    <div><btn v-on:click="brightness" value="">"$system.brightness: {{brightness}}"</btn></div>
    <div><btn v-on:click="system_volume" value="">"$system.volume: {{volume}}"</btn></div>
</div>
</template>

<script>
export default {
  name: "system",
  data() {
    return {
      brightness: "",
      volume: ""
    };
  },
  methods: {
    system_brightness: function(event) {
      JSBridge("sp://system/brightness?value=0.1")
        .then(result => {
          this.info = result;
        })
        .catch(err => {
          this.info = err;
        });
    },
    system_volume: function(event) {
      JSBridge("sp://system/volume?value=0.1")
        .then(result => {
          this.info = result;
        })
        .catch(err => {
          this.info = err;
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
