declare class Device {
    baseURL: string;
    info(): MTMessage;
}
declare class MT {
    device: Device;
}
