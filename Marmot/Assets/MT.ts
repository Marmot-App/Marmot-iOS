
class MT {
    device: MT_Device = new MT_Device()

    bridge(result) {
        var message = NativeEvent.shared.find(result['url'], result['id'])
        if (!message) { return }
        if (result['error']) {
            message.error = result['error']
            if (message._failure) message._failure(new Error(result['error']));
        } else {
            message.value = result['value']
            if (message._success) message._success(result['value']);
        }
        if (message._complete) message._complete(result)

        if (message.type == NativeMessageType.post) {
            NativeEvent.shared.remove(result['url'], result['id'])
            return
        }
    }
}


class MT_Device {

    private baseURL: string = 'mt://device/'

    info(): NativeMessage {
        return new NativeMessage(this.baseURL + '/info')
    }

}

window.mt = new MT()
