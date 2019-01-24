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

extension WKWebView: MarmotCompatible {
  
  fileprivate struct ObjectKey {
    static var handler = UnsafeRawPointer(bitPattern: "Marmot.WKWebView.handler".hashValue)!
  }
  
 fileprivate var handler: MarmotHandler {
    get {
      if let value = objc_getAssociatedObject(self, ObjectKey.handler) as? MarmotHandler {
        return value
      }else {
        self.handler = MarmotHandler(webview: self)
        return self.handler
      }
    }
    set {
      objc_setAssociatedObject(self, ObjectKey.handler, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
}

 public extension Marmot where Base: WKWebView {

 public func begin() {
    base.configuration.userContentController.add(base.handler, name: "marmot")
    let bundlePath = Bundle(for: MarmotHandler.self).bundlePath + "/Marmot.bundle/"
    try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
      .compactMap { $0.hasSuffix(".js") ? bundlePath + $0 : nil }
      .forEach { self.injectJS(path: $0) }
  }
  
 public func injectJS(path: String) {
    do {
      let js = try String(contentsOfFile: path, encoding: .utf8)
      self.injectJS(value: js)
    }catch {
      print(error.localizedDescription)
    }
  }
  
 public func injectJS(value: String) {
    let script = WKUserScript(source: value, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    base.configuration.userContentController.addUserScript(script)
  }
  
}
