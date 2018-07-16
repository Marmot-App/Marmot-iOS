<template>
<div>
    <div class="title">{{name}}</div>
    <el-collapse v-for="(item, index) in items" :key="item.index" accordion>

        <el-collapse-item class="subTitle" :title=item.title>

            <div class="block" v-if="item.slider">
                <span class="demonstration">默认</span>
                <el-slider v-model=item.body.value :min=item.slider.min :max=item.slider.max :step=item.slider.step show-input=true></el-slider>
            </div>

            <el-input v-if="item.placeholder" v-model="item.body.value" placeholder="请输入邮箱"></el-input>

            <el-button class="btn" type="success" size="medium" v-on:click="event(index)">点击运行</el-button>
            <div class="result-tips">返回示例:</div>
            <div class="result">{{item.result}}</div>
        </el-collapse-item>

    </el-collapse>
</div>
</template>

<script>
export default {
    name: "system",
    data() {
        return {
            name: "system",
            items: [{
                title: "system.brightness",
                event: "sp://system/brightness",
                body: {
                    value: 0
                },
                result: ""
            }, {
                title: "system.volume",
                event: "sp://system/volume",
                body: {
                    value: 0
                },
                result: ""
            }, {
                title: "system.call",
                placeholder: "请输入手机号",
                event: "sp://system/call",
                body: {
                    value: 0
                },
                result: ""
            }, {
                title: "system.sms",
                placeholder: "请输入手机号",

                event: "sp://system/sms",
                body: {
                    value: ""
                },
                result: ""
            }, {
                title: "system.mailto",
                placeholder: "请输入邮箱",

                event: "sp://system/mailto",
                body: {
                    value: ""
                },
                result: ""
            }, {
                title: "system.facetime",
                placeholder: "请输入邮箱",

                event: "sp://system/facetime",
                body: {
                    value: ""
                },
                result: ""
            }]
        };
    },
    methods: {
        event: function (index) {
            JSBridge(this.items[index].event, this.items[index].body)
                .then(result => {
                    this.items[index].result = result;
                })
                .catch(err => {
                    this.items[index] = err;
                });
        }

    }
};
</script>
