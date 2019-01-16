declare class MT_device {
    private baseURL;
    /**
     * 获取系统信息
     *
     * @returns {MTMessage}
     * @memberof MT_device
     */
    info(): MTMessage;
    /**
     *  获取设备的内存/磁盘空间：
     */
    space(): MTMessage;
    /**
     * 在有 Taptic Engine 的设备上触发一个轻微的振动
     * level: 0 ~ 2 表示振动等级
     * @param {string} level
     * @returns {MTMessage}
     * @memberof MT_device
     */
    taptic(level: string): MTMessage;
    /**
    * 打开/关闭 手电筒
    * level: 0 ~ 1
    * @param {string} level
    * @returns {MTMessage}
    * @memberof MT_device
    */
    torch(level: string): MTMessage;
}
declare class MT_clipboard {
    private baseURL;
    /**
     * 获取剪切板上文本
     *
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    text(): MTMessage;
    /**
     * 设置剪切板上文本
     *
     * @param {string} value
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    setText(value: string): MTMessage;
}
declare class MT_system {
    private baseURL;
    /**
     * 设置/获取 屏幕亮度
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    brightness(level: number): MTMessage;
    /**
     * 设置/获取 系统音量
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    volume(level: number): MTMessage;
    /**
     * 拨打电话
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    call(number: string): MTMessage;
    /**
     * 发送短信
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    sms(number: string): MTMessage;
    /**
     * 发送邮件
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    mailto(address: string): MTMessage;
    /**
     * FaceTime
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    facetime(address: string): MTMessage;
}
declare class MT_motion {
    private baseURL;
    /**
     * 开始监听 传感器
     *
     * @param {number} [updateInterval=0.1]
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    startUpdates(updateInterval?: number): MTMessage;
    /**
     * 停止监听传感器
     *
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    stopUpdates(): MTMessage;
}
declare class MT {
    device: MT_device;
    clipboard: MT_clipboard;
    system: MT_system;
    motion: MT_motion;
}
