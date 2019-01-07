//
//  MarmotHandler.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/5.
//

import Foundation
import WebKit
import Khala

struct MarmotMessage {
  
  var message: [String: Any] = [:]
  var url: String = ""
  var params: [String: Any]? = nil
  
}

class MarmotHandler: NSObject, WKScriptMessageHandler {
  
  weak var webView : WKWebView?
  
  init(webView: WKWebView) {
    self.webView = webView
    super.init()
  }
  
  
  func eval(dict: [String:Any]) {
    do {
      let data = try JSONSerialization.data(withJSONObject: dict, options: [])
      guard let json = String(data: data, encoding: .utf8) else { return }
      webView?.evaluateJavaScript("mt.bridge(\(json))", completionHandler: { (result, error) in
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
    
    guard let value = Khala(str: message.url,params: message.params ?? [:])?.call(block: {
      result["value"] = $0
      self.eval(dict: result)
    }) as? [String : Any] else { return }
    
    result["value"] = value
    self.eval(dict: result)
  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let body = message.body as? [String: Any] else { return }
    var message = MarmotMessage()
    message.message = body
    guard let url = body["url"] as? String  else { return }
    message.url = url
    
    if let params = body["params"] as? [String : Any] {
      message.params = params
    }
    
    actionHandler(message: message)
  }
  
}
