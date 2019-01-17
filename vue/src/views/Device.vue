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
      name: "device",
      items: [
        {
          title: "info - 系统信息",
          id: "info",

          demo:
            "mt.device.info().post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        },
        {
          title: "space - 系统空间信息",
          id: "space",
          demo:
            "mt.device.space().post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        },
        {
          title: "taptic - 震动",
          id: "taptic",
          demo: "mt.device.taptic(2).post()",
          result: ""
        },
        {
          title: "torch - 闪光灯",
          id: "torch",
          level: 0,
          demo:
            "mt.device.torch(2).post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      const item = this.items[index];
      switch (item.id) {
        case "taptic":
          mt.device.taptic(2).post(2);
          break;
        case "torch":
          mt.device
            .torch(0.5)
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
          break;
        case "space":
          mt.device
            .space()
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
          break;
        case "info":
          mt.device
            .info()
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
      }
    }
  }
};
</script>

<style scoped>
</style>
