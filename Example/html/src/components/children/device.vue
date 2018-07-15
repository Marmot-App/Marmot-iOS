<template>
<div>
  <div>device</div>
  <el-collapse accordion>
    <el-collapse-item title="$device.info">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_info">点击运行</el-button>
      </div>
      <div>"返回示例: {{info}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$device.ssid">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_ssid">点击运行</el-button>
      </div>
      <div>"返回示例: {{ssid}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$device.space">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_space">点击运行</el-button>
      </div>
      <div>"返回示例: {{space}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$device.taptic">
      <div>
        <div class="block">
          <span class="demonstration">默认</span>
          <el-slider v-model="taptic" max=3 step=1 show-input=true></el-slider>
        </div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_taptic">点击运行</el-button>
      </div>
      <div>"无返回示例"</div>
    </el-collapse-item>

  </el-collapse>
</div>

</template>

<script>
export default {
  name: "device",
  data() {
    return {
      activeName: "1",
      info: "",
      ssid: "",
      space: "",
      taptic: 0
    };
  },
  methods: {
    device_info: function(event) {
      if (this.info) {
        this.info = "";
        return;
      }
      JSBridge("sp://device/info")
        .then(result => {
          this.info = result;
        })
        .catch(err => {
          this.info = err;
        });
    },
    device_ssid: function(event) {
      if (this.ssid) {
        this.ssid = "";
        return;
      }
      JSBridge("sp://device/ssid")
        .then(result => {
          this.ssid = result;
        })
        .catch(err => {
          this.ssid = err;
        });
    },
    device_space: function(event) {
      if (this.space) {
        this.space = "";
        return;
      }
      JSBridge("sp://device/space")
        .then(result => {
          this.space = result;
        })
        .catch(err => {
          this.space = err;
        });
    },
    device_taptic: function(event) {
      JSBridge("sp://device/taptic?level=" + this.taptic)
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
.btn {
  width: 100%;
}
</style>
