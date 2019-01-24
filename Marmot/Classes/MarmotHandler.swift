//
//  Marmot
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

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
    var result = message.body
    var params = message.params ?? [:]
    params.updateValue(self, forKey: "webview")
    params.updateValue(["id": message.id], forKey: "request")
    
    guard let value = Khala(str: message.url,params: params)?.call(block: {
      // 处理属性赋值
      if $0["value"] == nil { result["value"] = $0 }
      else{ result["value"] = $0["value"] }
      self.eval(dict: result)
    }) else { return }
    
    // 处理属性赋值
    if let value = value as? KhalaInfo, value["value"] != nil {
      result["value"] = value["value"]
    }else{
      result["value"] = value
    }
    
    self.eval(dict: result)

  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let message = MarmotMessage(body: message.body) else { return }
    actionHandler(message: message)
  }
  
  
}

