<template>

<div>
  <div class="title">device</div>
  <el-collapse accordion>

    <el-collapse-item class="subTitle" title="$device.info">
      <el-button class="btn" type="danger" size="medium" v-on:click="device_info">点击运行</el-button>
      <div class="result-tips">返回示例:</div>
      <div class="result">{{info}}</div>
    </el-collapse-item>

    <el-collapse-item class="subTitle" title="$device.ssid">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_ssid">点击运行</el-button>
      </div>
      <div>"返回示例: {{ssid}}"</div>
    </el-collapse-item>

    <el-collapse-item class="subTitle" title="$device.space">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_space">点击运行</el-button>
      </div>
      <div>"返回示例: {{space}}"</div>
    </el-collapse-item>

    <el-collapse-item class="subTitle" title="$device.wlanAddress">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="device_wlanAddress">点击运行</el-button>
      </div>
      <div>"返回示例: {{wlanAddress}}"</div>
    </el-collapse-item>

    <el-collapse-item class="subTitle" title="$device.taptic">
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
      taptic: 0,
      wlanAddress: ""
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
          this.ssid = result;
        })
        .catch(err => {
          this.ssid = err;
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

    device_wlanAddress: function(event) {
      JSBridge("sp://device/wlanAddress")
        .then(result => {
          this.wlanAddress = result;
        })
        .catch(err => {
          this.wlanAddress = err;
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

