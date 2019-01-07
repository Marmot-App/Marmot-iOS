
declare class MTEvent {
    /**
     * message 存储集合
     *
     * @private
     * @type {({ [key: string]: { [key: number]: MTMessage | number; }; })}
     * @memberof MTEvent
     */
    private store;
    /**
     * 单例模式
     *
     * @static
     * @memberof MTEvent
     */
    static shared: MTEvent;
    private constructor();
    /**
     * 元素判空
     *
     * @private
     * @param {Object} obj
     * @returns
     * @memberof MTEvent
     */
    private isEmpty;
    /**
     * 添加 message 对象至集合
     *
     * @param {MTMessage} message
     * @returns {MTMessage}
     * @memberof MTEvent
     */
    update(message: MTMessage): MTMessage;
    /**
     * 查询 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns {(MTMessage | null)}
     * @memberof MTEvent
     */
    find(url: string, id: number): MTMessage | null;
    /**
     * 移除 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns
     * @memberof MTEvent
     */
    remove(url: string, id: number): any;
}
/**
 * 发送类型枚举
 *
 * @enum {number}
 */
declare enum MTMessageType {
    post = "post",
    listen = "listen"
}
declare class MTMessage {
    /**
     * 发送至 app 端 url 链接.
     *
     * @type {string}
     * @memberof MTMessage
     */
    url: string;
    /**
     * message id
     *
     * @type {number}
     * @memberof MTMessage
     */
    id: number;
    /**
     *  message 携带参数, 需要可解析为json字符串类型
     *
     * @type {object}
     * @memberof MTMessage
     */
    params: object;
    /**
     * 发送类型
     *
     * @type {MTMessageType}
     * @memberof MTMessage
     */
    type: MTMessageType;
    /**
     * 发送app数据
     *
     * @type {object}
     * @memberof MTMessage
     */
    message: object;
    /**
     * app 返回数据
     *
     * @type {object}
     * @memberof MTMessage
     */
    value: object;
    /**
     * app 返回错误
     *
     * @type {Error}
     * @memberof MTMessage
     */
    error: Error;
    /**
     * 成功回调
     *
     * @memberof MTMessage
     */
    _success: (value: object) => void;
    /**
     * 失败回调
     *
     * @memberof MTMessage
     */
    _failure: (error: Error) => void;
    /**
     * 执行完成回调
     *
     * @memberof MTMessage
     */
    _complete: (value: object) => void;
    /** 初始化函数
     *Creates an instance of NativeMessage.
     * @param {string} url
     * @memberof MTMessage
     */
    constructor(url: string);
    /**
     * 设置参数
     *
     * @param {object} value
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    setParam(value: object): MTMessage;
    /**
     * 设置成功回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    success(cb: (value: object) => void): MTMessage;
    /**
     * 设置失败回调
     *
     * @param {(error: Error) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    failure(cb: (error: Error) => void): MTMessage;
    /**
     * 设置完成回调
     *
     * @param {(value: object) => void} cb
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    complete(cb: (value: object) => void): MTMessage;
    /**
     * 单次异步回调
     *
     * @returns {Promise<object>}
     * @memberof MTMessage
     */
    post(): Promise<object>;
    /**
     * 监听
     *
     * @returns {MTMessage}
     * @memberof MTMessage
     */
    listen(): MTMessage;
    /**
     * 移除监听
     *
     * @memberof MTMessage
     */
    removeListen(): void;
}
