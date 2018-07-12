<template>
<div>
    <div><btn value="">"device"</btn></div>
    <div><btn v-on:click="getInfo" value="">"info: {{info}}"</btn></div>
    <div><btn v-on:click="getName" value="">"id: {{name}}"</btn></div>

</div>
</template>

<script>
export default {
  name: "device",
  data() {
    return {
      info: "",
      name: ""
    };
  },
  methods: {
    getInfo: function(event) {
      JSBridge("sp://device/info")
        .then(result => {
          this.info = result;
        })
        .catch(err => {
          this.info = err;
        });
    },
    getName: function(event) {
      JSBridge("sp://device/id")
        .then(result => {
          this.name = result;
        })
        .catch(err => {
          this.name = err;
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
