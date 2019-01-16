<template>
  <mt-base :name="name" :items="items" @runEvent="runEvent"></mt-base>
</template>

<script>
import MtBase from "../components/MTBase.vue";
export default {
  components: {
    MtBase
  },
  data() {
    return {
      message: undefined,
      name: "motion",
      items: [
        {
          title: "startUpdates - 监听传感器数据",
          id: "startUpdates",
          demo:
            "mt.motion.startUpdates()\n.success(value => {})\n.failure(error => {})\n.listen();",
          result: ""
        },
        {
          title: "stopUpdates - 停止监听传感器数据",
          id: "stopUpdates",
          demo: "mt.motion.stopUpdates()",
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      const item = this.items[index];
      switch (item.id) {
        case "stopUpdates":
          mt.motion.stopUpdates(this.message);
          break;
        case "startUpdates":
          this.message = mt.motion
            .startUpdates()
            .success(value => {
              this.items[index].result = value;
            })
            .failure(error => {
              this.items[index].result = error.message;
            })
            .listen();
      }
    }
  }
};
</script>

<style scoped>
</style>
