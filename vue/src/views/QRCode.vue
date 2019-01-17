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
      name: "qrcode",
      items: [
        {
          title: "scan - 开始扫描二维码",
          id: "scan",
          demo:
            "mt.qrcode.scan().post()\n.then(value => {})\n.catch(error => {})",
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      const item = this.items[index];
      switch (item.id) {
        case "scan":
          this.message = mt.qrcode
            .scan()
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
