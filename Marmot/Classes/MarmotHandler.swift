//
//  MarmotHandler.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/5.
//

import Foundation
import WebKit
import SPRoutable

class MarmotHandler: NSObject, WKScriptMessageHandler {
  
  weak var webView : WKWebView?
  
  init(webView: WKWebView) {
    self.webView = webView
    super.init()
  }
  
  func actionHandler(callBackId: String,url: URL,data: [String: Any]) {
    let res = Routable.object(url: url, params: data) {[weak self] (value) in
      self?.callback(to: callBackId, response: value)
    }
    
    guard let value = res else{ return }
    self.callback(to: callBackId, response: value)
  }
  
  
  func listen(to id: String,response: Any?) {
    
  }
  
  
  func callback(to id: String,response: Any?) {
    var function = "Native.callBack"
    
    guard let response = response else {
      webView?.evaluateJavaScript("\(function)('\(id)');")
      return
    }
    
    /// 监听属性
    if let dict = response as? [String: Any],
      let isListen = dict["isListen"] as? Bool,
      isListen {
      function = "Native.listen"
    }
    
    if JSONSerialization.isValidJSONObject(response) {
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions())
        if let json = String(data: jsonData, encoding: .utf8) {
          webView?.evaluateJavaScript("Native.callBack('\(id)','\(json)');")
          return
        }
      } catch {
        print("json format error:\(error)")
      }
    }
    
    webView?.evaluateJavaScript("Native.callBack('\(id)','\(response)');")
  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard message.name == Marmot.key,
      let dict = message.body as? [String: Any],
      let str = dict["url"] as? String,
      let id = dict["id"] as? String,
      let url = URL(string: str) else{ return }
    actionHandler(callBackId: id, url: url, data: dict["data"] as? [String: Any] ?? [:])
  }
  
}
