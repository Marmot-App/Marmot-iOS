var JSBridge = function JSBridge(url, data) {
  return new Promise(function (resolve, reject) {
                     Native.post(url, data, resolve, reject);
                     });
};

var Native = {
id: 0,
  
parserURL: function parserURL(urlObj) {
  var url = urlObj.toString();
  var a = document.createElement('a');
  a.href = url;
  return {
  protocol: a.protocol.replace(':', ''),
  host: a.hostname,
  query: a.search,
  path: a.pathname.replace(/^([^\/])/, '/$1'),
  params: function () {
    var ret = {};
    var seg = a.search.replace(/^\?/, '').split('&').filter(function (v, i) {
                                                            if (v !== '' && v.indexOf('=')) {
                                                            return true;
                                                            }
                                                            });
    seg.forEach(function (element, index) {
                var idx = element.indexOf('=');
                var key = element.substring(0, idx);
                var val = element.substring(idx + 1);
                ret[key] = val;
                });
    return ret;
  }()
  };
},
  
post: function post(url, params, successCB, failCB) {
  
  if (typeof url != 'string') {
    failCB('error: url 参数缺失');
  }
  
  if (typeof params === 'function') {
    successCB = params;
    params = {};
  }
  
  // url解析
  var urlObject = Native.parserURL(url);
  
  // 参数合并
  var dataObject = urlObject.params;
  for (var attr in params) {
    dataObject[attr] = params[attr];
  }
  
  var message = {
  url: "marmot://" + urlObject.host + urlObject.path,
  data: dataObject
  };
  
  if (typeof successCB == 'function') {
    this.id += 1;
    message.id = 'NativeEventId' + this.id;
    NativeEvent.addEvent(message.id, function (data) {
                         successCB(data);
                         });
  }
  window.webkit.messageHandlers.ios.postMessage(message);
},
  
callBack: function callBack(callBackID, data) {
  try {
    NativeEvent.fireEvent(callBackID, JSON.parse(data));
  } catch (error) {
    NativeEvent.fireEvent(callBackID, data);
  }
  NativeEvent.removeEvent(callBackID);
},
  
removeAllCallBacks: function removeAllCallBacks(data) {
  NativeEvent._listeners = {};
}
  
};

var NativeEvent = {
  
_listeners: {},
  
addEvent: function addEvent(type, fn) {
  if (typeof this._listeners[type] === "undefined") {
    this._listeners[type] = [];
  }
  if (typeof fn === "function") {
    this._listeners[type].push(fn);
  }
  
  return this;
},
  
fireEvent: function fireEvent(type, param) {
  var arrayEvent = this._listeners[type];
  if (arrayEvent instanceof Array) {
    for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
      if (typeof arrayEvent[i] === "function") {
        arrayEvent[i](param);
      }
    }
  }
  return this;
},
  
removeEvent: function removeEvent(type, fn) {
  var arrayEvent = this._listeners[type];
  if (typeof type === "string" && arrayEvent instanceof Array) {
    if (typeof fn === "function") {
      for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
        if (arrayEvent[i] === fn) {
          this._listeners[type].splice(i, 1);
          break;
        }
      }
    } else {
      delete this._listeners[type];
    }
  }
  
  return this;
}
};
