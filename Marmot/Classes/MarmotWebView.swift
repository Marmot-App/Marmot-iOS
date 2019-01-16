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

import WebKit
#if canImport(Khala)
import Khala
#endif

open class MarmotWebView: WKWebView {
  
  let userContentKey = "marmot"
    
  public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
    super.init(frame: frame, configuration: configuration)
    self.configuration.userContentController.add(self, name: userContentKey)
    let bundlePath = Bundle(for: MarmotWebView.self).bundlePath + "/Marmot.bundle/"
    try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
      .compactMap { $0.hasSuffix(".js") ? bundlePath + $0 : nil }
      .forEach { self.injectJSFlie(path: $0) }
  }
  
  public func injectJSFlie(path: String) {
    do {
      let js = try String(contentsOfFile: path, encoding: .utf8)
      self.injectJS(js)
    }catch {
      print(error.localizedDescription)
    }
  }
  
  public func injectJS(_ value: String) {
    let script = WKUserScript(source: value, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    self.configuration.userContentController.addUserScript(script)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MarmotWebView: WKScriptMessageHandler {
  
  func eval(dict: [String:Any]) {
    do {
      let data = try JSONSerialization.data(withJSONObject: dict, options: [])
      guard let json = String(data: data, encoding: .utf8) else { return }
      self.evaluateJavaScript("MTBridge(\(json))", completionHandler: { (result, error) in
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
