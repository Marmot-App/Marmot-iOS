
class MT_Device {

    private baseURL: string = 'mt://device/'

    public info(): MTMessage {
        return new MTMessage(this.baseURL + 'info')
    }

}


class MT_Notification {

    private baseURL: string = 'mt://notification/'

    /**
     * 监听 app 进入前台事件
     *
     * @param {(object) => void} cb
     * @returns {MTMessage}
     * @memberof MT_Notification
     */
    public enterForeground(cb: (object) => void): MTMessage {
        return new MTMessage(this.baseURL + 'enterForeground')
    }

}


class MT {

    public device: MT_Device = new MT_Device()
    public notification: MT_Notification = new MT_Notification()

}

window.mt = new MT();
