<template>
<div>
    <div v-for="(item, index) in items" :key="item.index">
        <router-link :id="item.name" :to="item.to" replace>
            <el-button class="btn" type="primary" size="medium">{{item.name}}</el-button>
        </router-link>
        <div style="height:5px"> </div>
    </div>
</div>
</template>

<script>
export default {
    name: "home",
    data() {
        return {
            items: [{
                to: "/children/device",
                name: "device"
            }, {
                to: "/children/system",
                name: "system"
            }, {
                to: "/children/push",
                name: "push"
            }]
        };
    }
};
</script>

<style>
.btn {
    width: 100%;
    text-align: center;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.title {
    text-align: center;
    font-size: 36px;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.subTitle {
    text-align: left;
    font-size: 30px;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.result-tips {
    font-size: 15px;
    line-height: 30px;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.result {
    background-color: #909399;
    color: #fff;
    font-size: 20px;
    line-height: 28px;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}
</style>
