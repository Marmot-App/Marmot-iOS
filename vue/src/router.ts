import Vue from 'vue';
import Router from 'vue-router';
import Index from './views/Index.vue';
import Device from './views/Device.vue';
import Clipboard from './views/Clipboard.vue'

Vue.use(Router);

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'index',
      component: Index,
    },
    {
      path: '/device',
      name: 'device',
      component: Device,
    },
    {
      path: '/clipboard',
      name: 'clipboard',
      component: Clipboard,
    },
  ],
});
