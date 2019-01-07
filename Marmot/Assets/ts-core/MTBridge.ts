window.MTBridge = (result) => {
    var message = MTEvent.shared.find(result['url'], result['id'])
    if (!message) { return }
    if (result['error']) {
        if (message._failure) message._failure(new Error(result['error']));
    } else {
        if (message._success) message._success(result['value']);
    }
    if (message._complete) message._complete(result)

    if (message.type == MTMessageType.post) {
        MTEvent.shared.remove(result['url'], result['id'])
        return
    }
}
