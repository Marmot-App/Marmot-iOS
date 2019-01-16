var MT_device = /** @class */ (function () {
    function MT_device() {
        this.baseURL = 'mt://device/';
    }
    MT_device.prototype.info = function () {
        return new MTMessage(this.baseURL + 'info');
    };
    return MT_device;
}());
var MT_clipboard = /** @class */ (function () {
    function MT_clipboard() {
        this.baseURL = 'mt://clipboard/';
    }
    MT_clipboard.prototype.text = function () {
        return new MTMessage(this.baseURL + 'text');
    };
    MT_clipboard.prototype.setText = function (value) {
        return new MTMessage(this.baseURL + 'setText').setParam({ value: value });
    };
    return MT_clipboard;
}());
var MT = /** @class */ (function () {
    function MT() {
        this.device = new MT_device();
        this.clipboard = new MT_clipboard();
    }
    return MT;
}());
window.mt = new MT();
