import Vue from 'vue'
import Router from 'vue-router'
import Device from '@/components/device'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/device',
      name: 'device',
      component: Device
    }
  ]
})
