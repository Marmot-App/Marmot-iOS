var MT_device = /** @class */ (function () {
    function MT_device() {
        this.baseURL = 'mt://device/';
    }
    /**
     * 获取系统信息
     *
     * @returns {MTMessage}
     * @memberof MT_device
     */
    MT_device.prototype.info = function () {
        return new MTMessage(this.baseURL + 'info');
    };
    /**
     *  获取设备的内存/磁盘空间：
     */
    MT_device.prototype.space = function () {
        return new MTMessage(this.baseURL + 'space');
    };
    /**
     * 在有 Taptic Engine 的设备上触发一个轻微的振动
     * level: 0 ~ 2 表示振动等级
     * @param {string} level
     * @returns {MTMessage}
     * @memberof MT_device
     */
    MT_device.prototype.taptic = function (level) {
        return new MTMessage(this.baseURL + 'taptic').setParam({ value: level });
    };
    /**
    * 打开/关闭 手电筒
    * level: 0 ~ 1
    * @param {string} level
    * @returns {MTMessage}
    * @memberof MT_device
    */
    MT_device.prototype.torch = function (level) {
        return new MTMessage(this.baseURL + 'torch').setParam({ value: level });
    };
    return MT_device;
}());
var MT_clipboard = /** @class */ (function () {
    function MT_clipboard() {
        this.baseURL = 'mt://clipboard/';
    }
    /**
     * 获取剪切板上文本
     *
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    MT_clipboard.prototype.text = function () {
        return new MTMessage(this.baseURL + 'text');
    };
    /**
     * 设置剪切板上文本
     *
     * @param {string} value
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    MT_clipboard.prototype.setText = function (value) {
        return new MTMessage(this.baseURL + 'setText').setParam({ value: value });
    };
    return MT_clipboard;
}());
var MT_system = /** @class */ (function () {
    function MT_system() {
        this.baseURL = 'mt://system/';
    }
    /**
     * 设置/获取 屏幕亮度
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.brightness = function (level) {
        return new MTMessage(this.baseURL + 'brightness').setParam({ value: level });
    };
    /**
     * 设置/获取 系统音量
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.volume = function (level) {
        return new MTMessage(this.baseURL + 'volume').setParam({ value: level });
    };
    /**
     * 拨打电话
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.call = function (number) {
        return new MTMessage(this.baseURL + 'call').setParam({ value: number });
    };
    /**
     * 发送短信
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.sms = function (number) {
        return new MTMessage(this.baseURL + 'sms').setParam({ value: number });
    };
    /**
     * 发送邮件
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.mailto = function (address) {
        return new MTMessage(this.baseURL + 'mailto').setParam({ value: address });
    };
    /**
     * FaceTime
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    MT_system.prototype.facetime = function (address) {
        return new MTMessage(this.baseURL + 'facetime').setParam({ value: address });
    };
    return MT_system;
}());
var MT_motion = /** @class */ (function () {
    function MT_motion() {
        this.baseURL = 'mt://motion/';
    }
    /**
     * 开始监听 传感器
     *
     * @param {number} [updateInterval=0.1]
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    MT_motion.prototype.startUpdates = function (updateInterval) {
        if (updateInterval === void 0) { updateInterval = 0.1; }
        return new MTMessage(this.baseURL + 'startUpdates').setParam({ updateInterval: updateInterval });
    };
    /**
     * 停止监听传感器
     *
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    MT_motion.prototype.stopUpdates = function () {
        return new MTMessage(this.baseURL + 'stopUpdates');
    };
    return MT_motion;
}());
var MT = /** @class */ (function () {
    function MT() {
        this.device = new MT_device();
        this.clipboard = new MT_clipboard();
        this.system = new MT_system();
        this.motion = new MT_motion();
    }
    return MT;
}());
window.mt = new MT();


