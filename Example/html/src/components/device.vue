<template>
<div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
    <div><btn v-on:click="greet" value="">add 1</btn></div>
</div>
</template>

<script>
export default {
    name: "device",
    data() {
        return {
            msg: "Welcome to Your Vue.js App"
        };
    },
    methods: {
        greet: function (event) {
            alert("Hello " + this.name + "!");
            if (event) {
                alert(event.target.tagName);
            }
        }
    }
};
</script>

<style scoped>
btn {}
</style>
