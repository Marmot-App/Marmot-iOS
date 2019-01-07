class MTEvent {
    /**
     * message 存储集合
     *
     * @private
     * @type {({ [key: string]: { [key: number]: MTMessage | number; }; })}
     * @memberof MTEvent
     */
    private store: { [key: string]: { [key: number]: MTMessage | number; }; } = {};

    /**
     * 单例模式
     *
     * @static
     * @memberof MTEvent
     */
    public static shared = new MTEvent();
    private constructor() { }

    /**
     * 元素判空
     *
     * @private
     * @param {Object} obj
     * @returns
     * @memberof MTEvent
     */
    private isEmpty(obj: Object) {
        return !obj || Object.keys(obj).length === 0;
    }

    /**
     * 添加 message 对象至集合
     *
     * @param {MTMessage} message
     * @returns {MTMessage}
     * @memberof MTEvent
     */
    update(message: MTMessage): MTMessage {
        if (this.isEmpty(MTEvent.shared.store[message.url])) {
            MTEvent.shared.store[message.url] = {};
            MTEvent.shared.store[message.url]['count'] = 0;
        }

        if (message.id) {
            MTEvent.shared.store[message.url][message.id] = message;
        } else {
            var count: number = <number>MTEvent.shared.store[message.url]['count'];
            count += 1;
            MTEvent.shared.store[message.url]['count'] = count;
            message.id = count;
            MTEvent.shared.store[message.url][count] = message;
        }

        return message;
    }

    /**
     * 查询 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns {(MTMessage | null)}
     * @memberof MTEvent
     */
    find(url: string, id: number): MTMessage | null {
        if (!MTEvent.shared.store[url])
            return null;
        if (!MTEvent.shared.store[url][id])
            return null;
        return <MTMessage>MTEvent.shared.store[url][id];
    }

    /**
     * 移除 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns
     * @memberof MTEvent
     */
    remove(url: string, id: number) {
        if (!MTEvent.shared.store[url])
            return null;
        if (!MTEvent.shared.store[url][id])
            return null;
        delete MTEvent.shared.store[url][id];
    }
}
