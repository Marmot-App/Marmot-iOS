<template>
<div>
    <div><btn value="">"home"</btn></div>
    <div><router-link id="device" to="/children/device">"$device"</router-link></div>
    <div><router-link id="device" to="/children/system">"$system"</router-link></div>
    <div><router-link id="device" to="/children/push">"$push"</router-link></div>
</div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {

    };
  },
  methods: {
    
  }
};
</script>

<style scoped>
#btn {
  background-color: cadetblue;
  height: 20px;
}
</style>
