
class NativeEvent {
    /**
     * message 存储集合
     * @private
     * @type {({ [key: string]: { [key: number]: NativeMessage | number; }; })}
     * @memberof NativeEvent
     */
    private store: { [key: string]: { [key: number]: NativeMessage | number; }; } = {};
    /**
     * 单例模式
     *
     * @static
     * @memberof NativeEvent
     */
    public static shared = new NativeEvent();
    private constructor() { }

    private isEmpty(obj: Object) {
        return !obj || Object.keys(obj).length === 0;
    }

    /**
     * 添加 message 对象至集合
     *
     * @param {NativeMessage} message
     * @returns {NativeMessage}
     * @memberof NativeEvent
     */
    update(message: NativeMessage): NativeMessage {
        if (this.isEmpty(NativeEvent.shared.store[message.url])) {
            NativeEvent.shared.store[message.url] = {};
            NativeEvent.shared.store[message.url]['count'] = 0;
        }

        if (message.id) {
            NativeEvent.shared.store[message.url][message.id] = message;
        } else {
            var count: number = <number>NativeEvent.shared.store[message.url]['count'];
            count += 1;
            NativeEvent.shared.store[message.url]['count'] = count;
            message.id = count;
            NativeEvent.shared.store[message.url][count] = message;
        }

        return message;
    }

    /**
     * 查询 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns {(NativeMessage | null)}
     * @memberof NativeEvent
     */
    find(url: string, id: number): NativeMessage | null {
        if (!NativeEvent.shared.store[url])
            return null;
        if (!NativeEvent.shared.store[url][id])
            return null;
        return <NativeMessage>NativeEvent.shared.store[url][id];
    }

    /**
     * 移除 message 对象
     *
     * @param {string} url
     * @param {number} id
     * @returns
     * @memberof NativeEvent
     */
    remove(url: string, id: number) {
        if (!NativeEvent.shared.store[url])
            return null;
        if (!NativeEvent.shared.store[url][id])
            return null;
        delete NativeEvent.shared.store[url][id];
    }
}
