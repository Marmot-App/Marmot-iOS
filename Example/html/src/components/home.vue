<template>
<div style="border:1px red solid">
    <el-button type="primary" size="medium" style="width:100%">home</el-button>
    <router-link id="device" to="/children/device"><el-button class="btn" type="danger"  size="medium" >device</el-button></router-link>
    <router-link id="system" to="/children/system"><el-button class="btn" type="primary" size="medium">system</el-button></router-link>
    <router-link id="push"   to="/children/push">  <el-button class="btn" type="danger"  size="medium">push</el-button></router-link>
</div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {};
  }
};
</script>

<style scoped>
.btn {
  width:100%
  
}
</style>
