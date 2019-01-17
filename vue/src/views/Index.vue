<template>
  <div>
    <router-link class="btn" v-for="(item) in items" :to="item" tag="div">{{item}}</router-link>
  </div>
</template>

<script>
import VueRouter from "vue-router";

export default {
  data() {
    return {
      items: ["device", "clipboard", "motion", "location", "qrcode"]
    };
  }
};
</script>


<style scoped>
.btn {
  margin-left: 10px;
  color: #fff;
  background-color: #409eff;
  border-color: #409eff;
  display: inline-block;
  line-height: 1;
  white-space: nowrap;
  cursor: pointer;
  border: 1px solid #dcdfe6;
  -webkit-appearance: none;
  text-align: center;
  box-sizing: border-box;
  outline: none;
  margin: 0;
  transition: 0.1s;
  font-weight: 500;
  padding: 12px 20px;
  font-size: 14px;
  border-radius: 4px;
  font-family: inherit;
  align-items: flex-start;
  text-rendering: auto;
  letter-spacing: normal;
  word-spacing: normal;
  text-transform: none;
  text-indent: 0px;
  text-shadow: none;
  font: 400 11px system-ui;
  -webkit-writing-mode: horizontal-tb !important;
}
</style>
