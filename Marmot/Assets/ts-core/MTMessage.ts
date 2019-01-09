
/**
 * 发送类型枚举
 *
 * @enum {number}
 */
enum MTMessageType {
    post = 'post',
    listen = 'listen'
}

class MTMessage {

    /**
     * 发送至 app 端 url 链接.
     *
     * @type {string}
     * @memberof MTMessage
     */
    public url: string;
    /**
     * message id
     *
     * @type {number}
     * @memberof MTMessage
     */
    public id: number;

    /**
     *  message 携带参数, 需要可解析为json字符串类型
     *
     * @type {object}
     * @memberof MTMessage
     */
    public params: object;

    /**
     * 发送类型
     *
     * @type {MTMessageType}
     * @memberof MTMessage
     */
    public type: MTMessageType;

    /**
     * 发送app数据
     *
     * @type {object}
     * @memberof MTMessage
     */
    public message: object;
    /**
     * 成功回调
     *
     * @memberof MTMessage
     */
    public _success: (value: object) => void;

    /**
     * 失败回调
     *
     * @memberof MTMessage
     */
    public _failure: (error: Error) => void;

    /**
     * 执行完成回调
     *
     * @memberof MTMessage
     */
    public _complete: (value: object) => void;

    /** 初始化函数
     *Creates an instance of NativeMessage.
     * @param {string} url
     * @memberof MTMessage
     */
    constructor(url: string) {
        this.url = url;
    }

    /**
     * 设置参数
     *
     * @param {object} value
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    setParam(value: object): MTMessage {
        this.params = value
        return this
    }

    /**
     * 设置成功回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    success(cb: (value: object) => void): MTMessage {
        this._success = cb
        return this
    }

    /**
     * 设置失败回调
     *
     * @param {(error: Error) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    failure(cb: (error: Error) => void): MTMessage {
        this._failure = cb
        return this
    }

    /**
     * 设置完成回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    complete(cb: (value: object) => void): MTMessage {
        this._complete = cb
        return this
    }

    /**
     * 单次异步回调
     *
     * @returns {Promise<object>}
     * @memberof MTMessage
     */
    post(): Promise<object> {

        var result: Promise<object>;
        if (!this._success && !this._failure) {
            result = new Promise((resolve, reject) => {
                this._success = resolve
                this._failure = reject
            });
        }

        this.id = MTEvent.shared.update(this).id
        this.type = MTMessageType.post
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        }

        window.webkit.messageHandlers.marmot.postMessage(this.message);
        return result
    }

    /**
     * 监听
     *
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    listen(): MTMessage {
        this.id = MTEvent.shared.update(this).id
        this.type = MTMessageType.listen
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        }
        window.webkit.messageHandlers.marmot.postMessage(this.message);
        return this
    }

    /**
     * 移除监听
     *
     * @memberof MTMessage
     */
    removeListen() {
        MTEvent.shared.remove(this.url, this.id)
    }

}
