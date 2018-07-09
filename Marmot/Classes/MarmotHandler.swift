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
  
  func actionHandler(callBackId: String,url: URL) {
    let urlCom = URLComponents(url: url, resolvingAgainstBaseURL: true)
    /// 参数提取
    var params: [String: Any] = [:]
    
    urlCom?.queryItems?.forEach({ (item) in
      params[item.name] = item.value
    })
    
    if let dataStr = (params["data"] as? String)?.replacingOccurrences(of: "*", with: "="),
      let data = Data(base64Encoded: dataStr) {
      params = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
    }
    let res = Routable.object(url: url, params: params) {[weak self] (value) in
      self?.callbackToJS(callBackId: callBackId, response: value)
    }
    
    self.callbackToJS(callBackId: callBackId, response: res)
  }
  
  func callbackToJS(callBackId: String,response: Any?) {
    guard let response = response else {
      webView?.evaluateJavaScript("Native.callBack('\(callBackId)');")
      return
    }
    
    if JSONSerialization.isValidJSONObject(response) {
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions())
        if let json = String(data: jsonData, encoding: .utf8) {
          webView?.evaluateJavaScript("Native.callBack('\(callBackId)','\(json)');")
          return
        }
      } catch {
        print("json format error:\(error)")
      }
    }
    
    webView?.evaluateJavaScript("Native.callBack('\(callBackId)','\(response)');")
  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard message.name == Marmot.key,
      let dict = message.body as? [String: Any],
      let str = dict["url"] as? String,
      let id = dict["id"] as? String,
      let url = URL(string: str) else{ return }
    actionHandler(callBackId: id, url: url)
  }
  
}
