import Device from './components/device.vue'

const routers = [
    {
        path: '/device',
        name: 'device',
        component: Device
    },
    {
        path: '/',
        component: Device
    },
]
export default routers
