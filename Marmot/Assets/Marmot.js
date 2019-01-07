window.MTBridge = function (result) {
    var message = MTEvent.shared.find(result['url'], result['id']);
    if (!message) {
        return;
    }
    if (result['error']) {
        if (message._failure)
            message._failure(new Error(result['error']));
    }
    else {
        if (message._success)
            message._success(result['value']);
    }
    if (message._complete)
        message._complete(result);
    if (message.type == MTMessageType.post) {
        MTEvent.shared.remove(result['url'], result['id']);
        return;
    }
};
var MTEvent = /** @class */ (function () {
    function MTEvent() {
        /**
         * message 存储集合
         *
         * @private
         * @type {({ [key: string]: { [key: number]: MTMessage | number; }; })}
         * @memberof MTEvent
         */
        this.store = {};
    }
    /**
     * 元素判空
     *
     * @private
     * @param {Object} obj
     * @returns
     * @memberof MTEvent
     */
    MTEvent.prototype.isEmpty = function (obj) {
        return !obj || Object.keys(obj).length === 0;
    };
    /**
     * 添加 message 对象至集合
     *
     * @param {MTMessage} message
     * @returns {MTMessage}
     * @memberof MTEvent
     */
    MTEvent.prototype.update = function (message) {
        if (this.isEmpty(MTEvent.shared.store[message.url])) {
            MTEvent.shared.store[message.url] = {};
            MTEvent.shared.store[message.url]['count'] = 0;
        }
        if (message.id) {
            MTEvent.shared.store[message.url][message.id] = message;
        }
        else {
            var count = MTEvent.shared.store[message.url]['count'];
            count += 1;
            MTEvent.shared.store[message.url]['count'] = count;
            message.id = count;
            MTEvent.shared.store[message.url][count] = message;
        }
        return message;
    };
    /**
     * 查询 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns {(MTMessage | null)}
     * @memberof MTEvent
     */
    MTEvent.prototype.find = function (url, id) {
        if (!MTEvent.shared.store[url])
            return null;
        if (!MTEvent.shared.store[url][id])
            return null;
        return MTEvent.shared.store[url][id];
    };
    /**
     * 移除 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns
     * @memberof MTEvent
     */
    MTEvent.prototype.remove = function (url, id) {
        if (!MTEvent.shared.store[url])
            return null;
        if (!MTEvent.shared.store[url][id])
            return null;
        delete MTEvent.shared.store[url][id];
    };
    /**
     * 单例模式
     *
     * @static
     * @memberof MTEvent
     */
    MTEvent.shared = new MTEvent();
    return MTEvent;
}());
/**
 * 发送类型枚举
 *
 * @enum {number}
 */
var MTMessageType;
(function (MTMessageType) {
    MTMessageType["post"] = "post";
    MTMessageType["listen"] = "listen";
})(MTMessageType || (MTMessageType = {}));
var MTMessage = /** @class */ (function () {
    /** 初始化函数
     *Creates an instance of NativeMessage.
     * @param {string} url
     * @memberof MTMessage
     */
    function MTMessage(url) {
        this.url = url;
    }
    /**
     * 设置参数
     *
     * @param {object} value
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    MTMessage.prototype.setParam = function (value) {
        this.params = value;
        return this;
    };
    /**
     * 设置成功回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    MTMessage.prototype.success = function (cb) {
        this._success = cb;
        return this;
    };
    /**
     * 设置失败回调
     *
     * @param {(error: Error) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    MTMessage.prototype.failure = function (cb) {
        this._failure = cb;
        return this;
    };
    /**
     * 设置完成回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    MTMessage.prototype.complete = function (cb) {
        this._complete = cb;
        return this;
    };
    /**
     * 单次异步回调
     *
     * @returns {Promise<object>}
     * @memberof MTMessage
     */
    MTMessage.prototype.post = function () {
        var _this = this;
        var result;
        if (!this._success && !this._failure) {
            result = new Promise(function (resolve, reject) {
                _this._success = resolve;
                _this._failure = reject;
            });
        }
        this.id = MTEvent.shared.update(this).id;
        this.type = MTMessageType.post;
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        };
        window.webkit.messageHandlers.ios.postMessage(this.message);
        return result;
    };
    /**
     * 监听
     *
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    MTMessage.prototype.listen = function () {
        this.id = MTEvent.shared.update(this).id;
        this.type = MTMessageType.listen;
        this.message = {
            id: this.id,
            url: this.url,
            param: this.params,
            type: this.type
        };
        window.webkit.messageHandlers.ios.postMessage(this.message);
        return this;
    };
    /**
     * 移除监听
     *
     * @memberof MTMessage
     */
    MTMessage.prototype.removeListen = function () {
        MTEvent.shared.remove(this.url, this.id);
    };
    return MTMessage;
}());
