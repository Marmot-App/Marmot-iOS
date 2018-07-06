//
//  MarmotHandler.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/5.
//

import Foundation
import WebKit

class MarmotHandler: NSObject, WKScriptMessageHandler {
  
  
  weak var webView : WKWebView?
  
  init(webView: WKWebView) {
    self.webView = webView
    super.init()
  }
  
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard message.name != Marmot.key else{ return }
    
    
  }
  
}
