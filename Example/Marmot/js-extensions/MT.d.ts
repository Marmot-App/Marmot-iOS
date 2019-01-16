declare class MT_device {
    private baseURL;
    info(): MTMessage;
}
declare class MT_clipboard {
    private baseURL;
    text(): MTMessage;
    setText(value: string): MTMessage;
}
declare class MT {
    device: MT_device;
    clipboard: MT_clipboard;
}
