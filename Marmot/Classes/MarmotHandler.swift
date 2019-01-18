//
//  MarmotHandle.swift
//  BLFoundation
//
//  Created by linhey on 2019/1/18.
//

import UIKit
import WebKit
import Khala

class MarmotHandler:NSObject, WKScriptMessageHandler {
  
  weak var webview: WKWebView? = nil
  
   init(webview: WKWebView) {
    super.init()
    self.webview = webview
  }
  
  func eval(dict: [String:Any]) {
    do {
      let data = try JSONSerialization.data(withJSONObject: dict, options: [])
      guard let json = String(data: data, encoding: .utf8) else { return }
      webview?.evaluateJavaScript("MTBridge(\(json))", completionHandler: { (result, error) in
        if error != nil {
          print(error?.localizedDescription ?? "")
        }
      })
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func actionHandler(message: MarmotMessage) {
    var result = message.message
    var params = message.params
    
    
    if params == nil {
      params = ["webview": self]
    }else{
      params?.updateValue(self, forKey: "webview")
    }
    
    guard let value = Khala(str: message.url,params: params ?? [:])?.call(block: {
      // 处理属性赋值
      if $0["value"] == nil { result["value"] = $0 }
      else{ result["value"] = $0["value"] }
      self.eval(dict: result)
    }) as? [String : Any] else { return }
    // 处理属性赋值
    if value["value"] == nil { result["value"] = value }
    else{ result["value"] = value["value"] }
    self.eval(dict: result)
  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let body = message.body as? [String: Any] else { return }
    var message = MarmotMessage()
    message.message = body
    guard let url = body["url"] as? String  else { return }
    message.url = url
    
    if let params = body["param"] as? [String : Any] {
      message.params = params
    }
    
    actionHandler(message: message)
  }
  
  
}

