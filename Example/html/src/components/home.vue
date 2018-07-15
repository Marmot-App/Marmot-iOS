<template>
<div style="border:1px red solid">
    <el-button type="primary" size="medium" style="width:100%">home</el-button>
    <router-link id="device" to="/children/device" replace><el-button class="btn" type="danger"  size="medium" >device</el-button></router-link>
    <router-link id="system" to="/children/system" replace><el-button class="btn" type="primary" size="medium">system</el-button></router-link>
    <router-link id="push"   to="/children/push"   replace><el-button class="btn" type="danger"  size="medium">push</el-button></router-link>
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

<style>
.btn {
  width: 100%;
  text-align: center;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.title {
  text-align: center;
  font-size: 36px;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.subTitle {
  text-align: left;
  font-size: 30px;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.result-tips {
  font-size: 15px;
  line-height: 30px;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.result {
  background-color: #909399;
  color: #fff;
  font-size: 20px;
  line-height: 28px;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}
</style>
