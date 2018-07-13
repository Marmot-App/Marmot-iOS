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
      JSBridge("sp://push/schedule?value=0.1")
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
