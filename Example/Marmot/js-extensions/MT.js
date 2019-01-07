var Device = /** @class */ (function () {
    function Device() {
        this.baseURL = 'mt://device/';
    }
    Device.prototype.info = function () {
        return new MTMessage(this.baseURL + 'info');
    };
    return Device;
}());
var MT = /** @class */ (function () {
    function MT() {
        this.device = new Device();
    }
    return MT;
}());
window.mt = new MT();
