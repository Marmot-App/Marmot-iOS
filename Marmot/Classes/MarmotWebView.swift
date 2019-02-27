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
  
  /// 缓存数据类型
  ///
  /// - diskCache: 在磁盘缓存上
  /// - offlineWebApplicationCache: html离线Web应用程序缓存
  /// - memoryCache: 内存缓存
  /// - localStorage: 本地存储
  /// - cookies: Cookies
  /// - sessionStorage: 会话存储
  /// - indexedDBDatabases: IndexedDB数据库
  /// - webSQLDatabases: 查询数据库
  public enum WebsiteDataTypes: String, CaseIterable {
    case diskCache = "WKWebsiteDataTypeDiskCache"
    case offlineWebApplicationCache = "WKWebsiteDataTypeOfflineWebApplicationCache"
    case memoryCache = "WKWebsiteDataTypeMemoryCache"
    case localStorage = "WKWebsiteDataTypeLocalStorage"
    case cookies = "WKWebsiteDataTypeCookies"
    case sessionStorage = "WKWebsiteDataTypeSessionStorage"
    case indexedDBDatabases = "WKWebsiteDataTypeIndexedDBDatabases"
    case webSQLDatabases = "WKWebsiteDataTypeWebSQLDatabases"
  }
  
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
  
  public func begin(injectJS: Bool = true) {
    base.configuration.userContentController.add(base.handler, name: "marmot")
    if injectJS {
      let bundlePath = Bundle(for: MarmotHandler.self).bundlePath + "/Marmot.bundle/"
      try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
        .compactMap { $0.hasSuffix(".js") ? bundlePath + $0 : nil }
        .forEach { self.injectJS(path: $0) }
    }
  }
  
  var customSchemes: [String]? {
    guard let controller = NSClassFromString("WKBrowsingContextController") as? NSObject.Type else { return nil }
    return controller.value(forKey: "customSchemes") as? [String]
  }
  
  /// 移除 webview 缓存
  ///
  /// - Parameter types: 缓存类型
  @available(iOS 9.0, *)
  public func removeData(types: [WKWebView.WebsiteDataTypes]){
    let set = Set(types.map({ $0.rawValue }))
    let date = Date(timeIntervalSince1970: 0)
    WKWebsiteDataStore.default().removeData(ofTypes: set, modifiedSince: date, completionHandler: { })
  }
  
  /// 移除 webview 缓存
  @available(iOS, introduced: 2.0, deprecated: 9.0, message: "please adopt removeData(types: [WKWebView.WebsiteDataTypes]).")
  public func removeData(){
    guard let libraryDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true).first else { return }
    let webkitFolderInLib = libraryDir + "/WebKit"
    let webKitFolderInCaches = "\(libraryDir)/Caches/\(libraryDir)/WebKit"
      /* iOS8.0 WebView Cache的存放路径 */
      try? FileManager.default.removeItem(atPath: webKitFolderInCaches)
      try? FileManager.default.removeItem(atPath: webkitFolderInLib)
  }
  
  var browsingContextController: NSObject.Type? {
    guard let inten = base.value(forKey: "browsingContextController") else { return nil }
    return type(of: inten) as? NSObject.Type
  }
  
  public func registerSchemeForCustomProtocol(schemes: [String]) {
    let sel = Selector(("registerSchemeForCustomProtocol:"))
    if let controller = browsingContextController, controller.responds(to: sel) {
      schemes.forEach({ controller.perform(sel, with: $0) })
    }
  }
  
  public func unregisterSchemeForCustomProtocol(schemes: [String]) {
    let sel = Selector(("unregisterSchemeForCustomProtocol:"))
    if let controller = browsingContextController, controller.responds(to: sel) {
      schemes.forEach({ controller.perform(sel, with: $0) })
    }
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
