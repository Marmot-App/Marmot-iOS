var mt = {}
mt.location = {}
mt.location.choose = function(cb) {
    Native.post('mt://location/fetch',cb)
}
