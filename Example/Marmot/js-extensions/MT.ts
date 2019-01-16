
class MT_device {

    private baseURL: string = 'mt://device/'

    /**
     * 获取系统信息
     *
     * @returns {MTMessage}
     * @memberof MT_device
     */
    public info(): MTMessage {
        return new MTMessage(this.baseURL + 'info')
    }

    /**
     *  获取设备的内存/磁盘空间：
     */
    public space(): MTMessage {
        return new MTMessage(this.baseURL + 'space')
    }

    /**
     * 在有 Taptic Engine 的设备上触发一个轻微的振动
     * level: 0 ~ 2 表示振动等级
     * @param {string} level
     * @returns {MTMessage}
     * @memberof MT_device
     */
    public taptic(level: string): MTMessage {
        return new MTMessage(this.baseURL + 'taptic').setParam({ value: level })
    }

    /**
    * 打开/关闭 手电筒
    * level: 0 ~ 1
    * @param {string} level
    * @returns {MTMessage}
    * @memberof MT_device
    */
    public torch(level: string): MTMessage {
        return new MTMessage(this.baseURL + 'torch').setParam({ value: level })
    }
}

class MT_clipboard {

    private baseURL: string = 'mt://clipboard/'

    /**
     * 获取剪切板上文本
     *
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    public text(): MTMessage {
        return new MTMessage(this.baseURL + 'text')
    }

    /**
     * 设置剪切板上文本
     *
     * @param {string} value
     * @returns {MTMessage}
     * @memberof MT_clipboard
     */
    public setText(value: string): MTMessage {
        return new MTMessage(this.baseURL + 'setText').setParam({ value: value })
    }

}

class MT_system {

    private baseURL: string = 'mt://system/'

    /**
     * 设置/获取 屏幕亮度
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    brightness(level: number): MTMessage {
        return new MTMessage(this.baseURL + 'brightness').setParam({ value: level })
    }

    /**
     * 设置/获取 系统音量
     *
     * @param {number} value | 0 ~ 1之间
     * @returns {MTMessage}
     * @memberof MT_system
     */
    volume(level: number): MTMessage {
        return new MTMessage(this.baseURL + 'volume').setParam({ value: level })
    }

    /**
     * 拨打电话
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    call(number: string): MTMessage {
        return new MTMessage(this.baseURL + 'call').setParam({ value: number })
    }

    /**
     * 发送短信
     *
     * @param {string} number | 手机号码
     * @returns {MTMessage}
     * @memberof MT_system
     */
    sms(number: string): MTMessage {
        return new MTMessage(this.baseURL + 'sms').setParam({ value: number })
    }

    /**
     * 发送邮件
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    mailto(address: string): MTMessage {
        return new MTMessage(this.baseURL + 'mailto').setParam({ value: address })
    }

    /**
     * FaceTime
     *
     * @param {string} number | 邮件地址
     * @returns {MTMessage}
     * @memberof MT_system
     */
    facetime(address: string): MTMessage {
        return new MTMessage(this.baseURL + 'facetime').setParam({ value: address })
    }
}

class MT_motion {
    private baseURL: string = 'mt://motion/'

    /**
     * 开始监听 传感器
     *
     * @param {number} [updateInterval=0.1]
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    startUpdates(updateInterval: number = 0.1): MTMessage {
        return new MTMessage(this.baseURL + 'startUpdates').setParam({ updateInterval: updateInterval })
    }

    /**
     * 停止监听传感器
     *
     * @returns {MTMessage}
     * @memberof MT_motion
     */
    stopUpdates(): MTMessage {
        return new MTMessage(this.baseURL + 'stopUpdates')
    }

}

class MT {

    public device: MT_device = new MT_device()
    public clipboard: MT_clipboard = new MT_clipboard()
    public system: MT_system = new MT_system()
    public motion: MT_motion = new MT_motion()

}

window.mt = new MT();
