import Vue from 'vue';
import Router from 'vue-router';
import Index from './views/Index.vue';
import Device from './views/Device.vue';
import Clipboard from './views/Clipboard.vue'
import Motion from './views/Motion.vue'
import Location from './views/Location.vue'
import QRCode from './views/QRCode.vue'

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
    {
      path: '/motion',
      name: 'motion',
      component: Motion,
    },
    {
      path: '/location',
      name: 'location',
      component: Location,
    },
    {
      path: '/qrcode',
      name: 'qrcode',
      component: QRCode,
    }
  ],
});
