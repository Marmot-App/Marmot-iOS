<template>
  <div>
    <h1>{{name}}</h1>
    <el-collapse v-for="(item,index) in items" :key="item.index" accordion>
      <el-collapse-item :title="item.title">
        <el-row>
          <el-col :span="24">
            <div class="code">Api调用示例:</div>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <div class="code">{{items[index].demo}}</div>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <el-button class="btn" type="success" size="medium" v-on:click="runEvent(index)">点击运行</el-button>
          </el-col>
        </el-row>

        <div class="code-title" v-if="item.result != ''">返回示例:</div>

        <div class="code" v-if="item.result != ''">{{item.result}}</div>
      </el-collapse-item>
    </el-collapse>
  </div>
</template>

<script>
export default {
  props: ["name", "items"],
  data() {
    return {};
  },
  methods: {
    runEvent(index) {
      this.$emit("runEvent", index);
    }
  }
};
</script>


<style>
.btn {
  width: 100%;
  text-align: center;
}
.code-box {
  width: 100%;
  overflow: hidden;
}
.code-title {
  width: 100%;
}
.code {
  text-align: left;
  background-color: #f5f5f5;
  white-space: pre-wrap;
  margin: 0;
}
</style>
