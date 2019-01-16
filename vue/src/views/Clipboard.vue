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
          title: "text",
          demo: [
            "mt.device.text() \n .success((value) => {}) \n .failure((error) => {}) \n .complete((value) => {}) \n .post()",
            "mt.device.text() \n .post() \n .then(value => {}) \n .catch(error => {})"
          ],
          result: ""
        },
        {
          title: "setText",
          demo: [
            "mt.device.setText() \n .success((value) => {}) \n .failure((error) => {}) \n .complete((value) => {}) \n .post()",
            "mt.device.setText() \n .post() \n .then(value => {}) \n .catch(error => {})"
          ],
          result: ""
        }
      ]
    };
  },
  methods: {
    runEvent(index) {
      const item = this.items[index];
      switch (item.title) {
        case "setText":
          mt.clipboard
            .setText("66666")
            .post()
            .then(value => {
              this.items[index].result = value;
            })
            .catch(error => {
              this.items[index].result = error.message;
            });
          break;
        case "text":
          mt.clipboard
            .text()
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
