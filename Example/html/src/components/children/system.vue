<template>

<div>
  <div>system</div>
  <el-collapse accordion>

    <el-collapse-item title="$system.brightness">
      <div>
        <div class="block">
          <span class="demonstration">默认</span>
          <el-slider v-model="brightness_value" max=1 step=0.1 show-input=true></el-slider>
        </div>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_brightness">点击运行</el-button>
      </div>
      <div>"返回示例: {{brightness}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$system.volume">
      <div>
        <div class="block">
          <span class="demonstration">默认</span>
          <el-slider v-model="volume_value" max=1 step=0.1 show-input=true></el-slider>
        </div>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_volume">点击运行</el-button>
      </div>
      <div>"返回示例: {{volume}}"</div>
    </el-collapse-item>

  </el-collapse>
</div>


</template>

<script>
export default {
  name: "system",
  data() {
    return {
      brightness_value: 0,
      brightness: "",

      volume_value: 0,
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
.btn {
  width: 100%;
}
</style>
