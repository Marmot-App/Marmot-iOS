<template>
<div>
    <div class="title">{{name}}</div>
    <el-collapse v-for="(item, index) in items" :key="item.index" accordion>

        <el-collapse-item class="subTitle" :title=item.title>
            <div class="block" v-if="item.slider">
                <span class="demonstration">默认</span>
                <el-slider v-model=item.body.value :min=item.slider.min :max=item.slider.max :step=item.slider.step show-input=true></el-slider>
            </div>

            <el-button class="btn" type="success" size="medium" v-on:click="event(index)">点击运行</el-button>
            <div class="result-tips">返回示例:</div>
            <div class="result">{{item.result}}</div>
        </el-collapse-item>

    </el-collapse>
</div>
</template>

<script>
export default {
    name: "device",
    data() {
        return {
            name: "device",
            items: [{
                    title: "device.info",
                    event: "sp://device/info",
                    result: ""
                },
                {
                    title: "device.ssid",
                    event: "sp://device/ssid",
                    result: ""
                },
                {
                    title: "device.space",
                    event: "sp://device/space",
                    result: ""
                },
                {
                    title: "device.wlanAddress",
                    event: "sp://device/wlanAddress",
                    result: ""
                },
                {
                    title: "device.taptic",
                    event: "sp://device/taptic",
                    body: {
                        value: 0
                    },
                    slider: {
                        max: 2,
                        min: 0,
                        step: 1
                    },
                    result: ""
                }
            ],
        };
    },

    methods: {
        event: function (index) {
            JSBridge(this.items[index].event, this.items[index].event.body)
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
