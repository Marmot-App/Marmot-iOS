var MT_Device = /** @class */ (function () {
    function MT_Device() {
        this.baseURL = 'mt://device/';
    }
    MT_Device.prototype.info = function () {
        return new MTMessage(this.baseURL + 'info');
    };
    return MT_Device;
}());
var MT_Notification = /** @class */ (function () {
    function MT_Notification() {
        this.baseURL = 'mt://notification/';
    }
    /**
     * 监听 app 进入前台事件
     *
     * @param {(object) => void} cb
     * @returns {MTMessage}
     * @memberof MT_Notification
     */
    MT_Notification.prototype.enterForeground = function (cb) {
        return new MTMessage(this.baseURL + 'enterForeground');
    };
    return MT_Notification;
}());
var MT = /** @class */ (function () {
    function MT() {
        this.device = new MT_Device();
        this.notification = new MT_Notification();
    }
    return MT;
}());
window.mt = new MT();
