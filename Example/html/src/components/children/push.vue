<template>
<div>
  <div>"push"</div>
  <el-collapse accordion>

    <el-collapse-item title="$push.schedule">
      <div>
        <el-button class="btn" type="danger" size="medium" v-on:click="push_schedule">点击运行</el-button>
      </div>
      <div>"返回示例: {{schedule}}"</div>
    </el-collapse-item>

  </el-collapse>
</div>

</template>

<script>
export default {
  name: "push",
  data() {
    return {
      schedule: "",
      id: []
    };
  },
  methods: {
    push_schedule: function(event) {
      let date = new Date();
      date.setSeconds(date.getSeconds() + 5);
      JSBridge("sp://push/schedule", {
        title: "标题",
        body: "内容",
        delay: 5,
        query: {
          value1: "额外参数",
          value2: "额外参数"
        },
        badge: "2"
      })
        .then(result => {
          this.schedule = result;
        })
        .catch(err => {
          this.schedule = err;
        });
    }
  }
};
</script>
