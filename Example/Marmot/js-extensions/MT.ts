
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

class MT {

    public device: MT_device = new MT_device()
    public clipboard: MT_clipboard = new MT_clipboard()

}

window.mt = new MT();
