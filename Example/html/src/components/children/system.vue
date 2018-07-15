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

    <el-collapse-item title="$system.call">
      <div>
        <el-input v-model="call_value" placeholder="请输入手机号"></el-input>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_call">点击运行</el-button>
      </div>
      <div>"返回示例: {{call}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$system.sms">
      <div>
        <el-input v-model="sms_value" placeholder="请输入手机号"></el-input>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_sms">点击运行</el-button>
      </div>
      <div>"返回示例: {{sms}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$system.mailto">
      <div>
        <el-input v-model="mailto_value" placeholder="请输入邮箱"></el-input>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_mailto">点击运行</el-button>
      </div>
      <div>"返回示例: {{mailto}}"</div>
    </el-collapse-item>

    <el-collapse-item title="$system.facetime">
      <div>
        <el-input v-model="facetime_value" placeholder="请输入邮箱"></el-input>
        <el-button class="btn" type="danger" size="medium" v-on:click="system_facetime">点击运行</el-button>
      </div>
      <div>"返回示例: {{facetime}}"</div>
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
      volume: "",

      call_value: "",
      call: "",

      sms_value: "",
      sms: "",

      mailto_value: "",
      mailto: "",

      facetime_value: "",
      facetime: ""
    };
  },
  methods: {
    system_brightness: function(event) {
      JSBridge("sp://system/brightness?value=" + this.brightness_value)
        .then(result => {
          this.brightness = result;
        })
        .catch(err => {
          this.brightness_value = err;
        });
    },
    system_volume: function(event) {
      JSBridge("sp://system/volume?value=" + this.volume_value)
        .then(result => {
          this.volume = result;
        })
        .catch(err => {
          this.volume = err;
        });
    },
    system_call: function(event) {
      JSBridge("sp://system/call?value=" + this.call_value)
        .then(result => {
          this.call = result;
        })
        .catch(err => {
          this.call = err;
        });
    },
        system_sms: function(event) {
      JSBridge("sp://system/sms?value=" + this.sms_value)
        .then(result => {
          this.sms = result;
        })
        .catch(err => {
          this.sms = err;
        });
    },
        system_mailto: function(event) {
      JSBridge("sp://system/mailto?value=" + this.mailto_value)
        .then(result => {
          this.mailto = result;
        })
        .catch(err => {
          this.mailto = err;
        });
    },
        system_facetime: function(event) {
      JSBridge("sp://system/facetime?value=" + this.call_value)
        .then(result => {
          this.facetime = result;
        })
        .catch(err => {
          this.facetime = err;
        });
    }
  }
};
</script>