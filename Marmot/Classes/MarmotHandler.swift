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
  
  enum Event: String {
    case callback = "Native.callBack"
    case listen = "Native.listen"
  }
  
  weak var webView : WKWebView?
  
  init(webView: WKWebView) {
    self.webView = webView
    super.init()
  }
  
  func actionHandler(callBackId: String,url: URL,data: [String: Any]) {
    let isListen = data["isListen"] as? Bool ?? false
    let type: Event = isListen ? .listen : .callback
    let res = Routable.object(url: url, params: data) {[weak self] (value) in
      self?.runJSEvent(to: callBackId, type: type, response: value)
    }
    guard let value = res else{ return }
    self.runJSEvent(to: callBackId, type: type, response: value)
  }
  
  func runJSEvent(to id: String,type: Event,response: Any?) {
    guard let response = response else {
      webView?.evaluateJavaScript("\(type.rawValue)('\(id)');")
      return
    }
    
    if JSONSerialization.isValidJSONObject(response) {
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions())
        if let json = String(data: jsonData, encoding: .utf8) {
          webView?.evaluateJavaScript("\(type.rawValue)('\(id)','\(json)');")
          return
        }
      } catch {
        print("json format error:\(error)")
      }
    }
    
    webView?.evaluateJavaScript("\(type.rawValue)('\(id)','\(response)');")
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
