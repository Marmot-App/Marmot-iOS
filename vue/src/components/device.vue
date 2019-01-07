<template>
  <mt-base :name="name" :items="items" @runEvent="runEvent"></mt-base>
</template>

<script>
import MtBase from "./MTBase";
export default {
  components: {
    MtBase
  },
  data() {
    return {
      name: "device",
      items: [
        {
          title: "info",
          demo: [
            "mt.device.info() \n .success((value) => {}) \n .failure((error) => {}) \n .complete((value) => {}) \n .post()",
            "mt.device.info() \n .post() \n .then(value => {}) \n .catch(error => {})"
          ],
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      var item = this.items[index];
      switch (item.title) {
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
