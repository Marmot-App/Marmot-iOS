declare class MT_Device {
    private baseURL;
    info(): MTMessage;
}
declare class MT_Notification {
    private baseURL;
    /**
     * 监听 app 进入前台事件
     *
     * @param {(object) => void} cb
     * @returns {MTMessage}
     * @memberof MT_Notification
     */
    enterForeground(cb: (object: any) => void): MTMessage;
}
declare class MT {
    device: MT_Device;
    notification: MT_Notification;
}
