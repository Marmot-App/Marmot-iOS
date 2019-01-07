/**
 * 发送类型枚举
 *
 * @enum {number}
 */
enum NativeMessageType {
    post = 'post',
    listen = 'listen'
}

class NativeMessage {

    /**
     * 发送至 app 端 url 链接.
     *
     * @type {string}
     * @memberof NativeMessage
     */

    public url: string;
    /**
     * message id
     *
     * @type {number}
     * @memberof NativeMessage
     */
    public id: number;

    /**
     *  message 携带参数, 需要可解析为json字符串类型
     *
     * @type {object}
     * @memberof NativeMessage
     */
    public params: object;

    /**
     * 发送类型
     *
     * @type {NativeMessageType}
     * @memberof NativeMessage
     */
    public type: NativeMessageType;

    /**
     * 发送app数据
     *
     * @type {object}
     * @memberof NativeMessage
     */
    public message: object;

    /**
     * app 返回数据
     *
     * @type {object}
     * @memberof NativeMessage
     */
    public value: object;

    /**
     * app 返回错误
     *
     * @type {Error}
     * @memberof NativeMessage
     */
    public error: Error;

    /**
     * 成功回调
     *
     * @memberof NativeMessage
     */
    public _success: (value: object) => void;

    /**
     * 失败回调
     *
     * @memberof NativeMessage
     */
    public _failure: (error: Error) => void;

    /**
     * 执行完成回调
     *
     * @memberof NativeMessage
     */
    public _complete: (value: object) => void;

    /** 初始化函数
     *Creates an instance of NativeMessage.
     * @param {string} url
     * @memberof NativeMessage
     */
    constructor(url: string) {
        this.url = url;
    }

    /**
     * 设置参数
     *
     * @param {object} value
     * @returns {NativeMessage}
     * @memberof NativeMessage
     */
    setParam(value: object): NativeMessage {
        this.params = value
        return this
    }

    /**
     * 设置成功回调
     *
     * @param {(value: object) => void} cb
     * @returns {NativeMessage}
     * @memberof NativeMessage
     */
    success(cb: (value: object) => void): NativeMessage {
        this._success = cb
        return this
    }

    /**
     * 设置失败回调
     *
     * @param {(error: Error) => void} cb
     * @returns {NativeMessage}
     * @memberof NativeMessage
     */
    failure(cb: (error: Error) => void): NativeMessage {
        this._failure = cb
        return this
    }

    /**
     * 设置完成回调
     *
     * @param {(value: object) => void} cb
     * @returns {NativeMessage}
     * @memberof NativeMessage
     */
    complete(cb: (value: object) => void): NativeMessage {
        this._complete = cb
        return this
    }

    /**
     * 单次异步回调
     *
     * @returns {Promise<object>}
     * @memberof NativeMessage
     */
    post(): Promise<object> {

        var result: Promise<object>;
        if (!this._success && !this._failure) {
            result = new Promise((resolve, reject) => {
                this._success = resolve
                this._failure = reject
            });
        }

        this.id = NativeEvent.shared.update(this).id
        this.type = NativeMessageType.post
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        }

        window.webkit.messageHandlers.ios.postMessage(this.message);
        return result
    }

    /**
     * 监听
     *
     * @returns {NativeMessage}
     * @memberof NativeMessage
     */
    listen(): NativeMessage {
        this.id = NativeEvent.shared.update(this).id
        this.type = NativeMessageType.listen
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        }
        window.webkit.messageHandlers.ios.postMessage(this.message);
        return this
    }

    /**
     * 移除监听
     *
     * @memberof NativeMessage
     */
    removeListen() {
        NativeEvent.shared.remove(this.url, this.id)
    }

}


