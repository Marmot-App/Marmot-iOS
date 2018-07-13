<template>
<div>
    <div><btn value="">"device"</btn></div>
    <div><btn v-on:click="device_info" value="">"$device.info: {{info}}"</btn></div>
    <div><btn v-on:click="device_ssid" value="">"$device.ssid: {{ssid}}"</btn></div>
    <div><btn v-on:click="device_space" value="">"$device.space: {{space}}"</btn></div>
    <div><btn v-on:click="device_taptic" value="">"$device.taptic(1)"</btn></div>
</div>
</template>

<script>
export default {
  name: "device",
  data() {
    return {
      info: "",
      ssid: "",
      space: ""
    };
  },
  methods: {
    device_info: function(event) {
      JSBridge("sp://device/info")
        .then(result => {
          this.info = result;
        })
        .catch(err => {
          this.info = err;
        });
    },
    device_ssid: function(event) {
      JSBridge("sp://device/ssid")
        .then(result => {
          this.name = result;
        })
        .catch(err => {
          this.name = err;
        });
    },
    device_space: function(event) {
      JSBridge("sp://device/space")
        .then(result => {
          this.space = result;
        })
        .catch(err => {
          this.space = err;
        });
    },
    device_taptic: function(event) {
      JSBridge("sp://device/taptic?level=0")
        .then(result => {
          this.space = result;
        })
        .catch(err => {
          this.space = err;
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
