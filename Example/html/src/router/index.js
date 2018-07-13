import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/home'
import Device from '@/components/children/device'
import System from '@/components/children/system'
import Push from '@/components/children/push'

Vue.use(Router)

export default new Router({
  routes: [{
    path: '/home',
    name: 'home',
    component: Home
  }, {
    path: '/children/device',
    name: 'device',
    component: Device
  }, {
    path: '/children/system',
    name: 'system',
    component: System
  }, {
    path: '/children/push',
    name: 'push',
    component: Push
  }]
})
