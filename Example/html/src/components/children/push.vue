<template>
<div>
    <div><btn value="">"push"</btn></div>
    <div><btn v-on:click="push_schedule" value="">"$push.schedule: {{schedule}}"</btn></div>
</div>
</template>

<script>
export default {
  name: "push",
  data() {
    return {
      schedule: ""
    };
  },
  methods: {
    push_schedule: function(event) {
      let date = new Date();
      date.setSeconds(date.getSeconds() + 5);
      JSBridge("sp://push/schedule", {
        title: "标题",
        body: "内容",
        date: date,
        delay: 10,
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

<style scoped>
#btn {
  background-color: cadetblue;
  height: 20px;
}
</style>
