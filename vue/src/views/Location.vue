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
      name: "location",
      updatingMessage: undefined,
      headingUpdateMessage: undefined,
      items: [
        {
          title: "select - 从地图上选择一个点",
          id: "select",
          demo:
            "mt.device.select().post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        },
        {
          title: "fetch - 单次定位",
          id: "fetch",
          demo:
            "mt.device.fetch().post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        },
        {
          title: "updating - 监听定位位置",
          id: "updating",
          demo:
            "mt.motion.updating()\n.then(value => {})\n.catch(error => {})\n.listen();",
          result: ""
        },
        {
          title: "stopUpdate - 移除定位更新",
          id: "stopUpdate",
          demo: "mt.motion.stopUpdate(message);",
          result: ""
        },
        {
          title: "updatingHeading - 监听罗盘",
          id: "updatingHeading",
          demo:
            "mt.motion.updatingHeading()\n.then(value => {})\n.catch(error => {})\n.listen();",
          result: ""
        },
        {
          title: "stopHeadingUpdate - 移除罗盘监听",
          id: "stopHeadingUpdate",
          demo: "mt.motion.stopHeadingUpdate(message);",
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      const item = this.items[index];
      switch (item.id) {
        case "stopHeadingUpdate":
          mt.location.stopHeadingUpdate(this.headingUpdateMessage);
          break;
        case "updatingHeading":
          this.headingUpdateMessage = mt.location
            .updatingHeading()
            .success(value => {
              this.items[index].result = value;
            })
            .failure(error => {
              this.items[index].result = error.message;
            })
            .listen();
          break;
        case "stopUpdate":
          mt.location.stopUpdate(this.updatingMessage);
          break;
        case "updating":
          this.updatingMessage = mt.location
            .updating()
            .success(value => {
              this.items[index].result = value;
            })
            .failure(error => {
              this.items[index].result = error.message;
            })
            .listen();
          break;
        case "fetch":
          mt.location
            .fetch()
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
          break;
        case "select":
          mt.location
            .select()
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
          break;
        case "startUpdates":
          mt.motion
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
