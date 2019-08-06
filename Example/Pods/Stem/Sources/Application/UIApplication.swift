//
//  Stem
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


public extension Stem where Base: UIApplication {

    /// 是否已开启推送
    var isOpenNotification: Bool {
        if let type = UIApplication.shared.currentUserNotificationSettings?.types, type == .init(rawValue: 0) { return false}
        else { return true }
    }

}

public extension UIApplication {
    
    struct Info {
        /// App版本号
         let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        /// App构建版本号
         let bundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
         let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
         let bundleID = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? ""
    }
    
    struct Path {
        var documentsURL: URL? { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last }
        var documentsPath: String? { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first }
        var cachesURL: URL? { return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last }
        var cachesPath: String? { return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first }
        var libraryURL: URL? { return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last }
        var libraryPath: String? { return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first }
    }
    
    enum OpenURLType {
        case tel(number: String)
        case sms(number: String)
        case telprompt(number: String)
        case safari(url: URL)
        case mailto(email: String)
        case appSettings
        
        public var url: URL {
            switch self {
            case .tel(number: let value): return URL(string: "tel://" + value)!
            case .sms(number: let value): return URL(string: "sms://" + value)!
            case .telprompt(number: let value): return URL(string: "telprompt://" + value)!
            case .safari(url: let value):  return value
            case .mailto(email: let value): return URL(string: "mailto://" + value)!
            case .appSettings: return URL(string: UIApplication.openSettingsURLString)!
            }
        }
        
    }
    
}

public extension Stem where Base: UIApplication {
    
    var info: UIApplication.Info { return UIApplication.Info() }
    var path: UIApplication.Path { return UIApplication.Path() }
    
}

// MARK: - open
public extension Stem where Base: UIApplication {
    
    /// 打开特定链接
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completionHandler: 完成回调
    func open(type: UIApplication.OpenURLType, completionHandler: ((Bool) -> Void)? = nil) {
        open(url: type.url, completionHandler: completionHandler)
    }
    
    /// 打开链接
    ///
    /// - Parameters:
    ///   - url: url
    ///   - isSafe: 会判断 能否打开 | default: true
    ///   - options: UIApplication.OpenExternalURLOptionsKey
    ///   - completionHandler: 完成回调
    func open(url: String,
              isSafe: Bool = true,
              options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
              completionHandler: ((Bool) -> Void)? = nil) {
        guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) else{ return }
        open(url: url, isSafe: isSafe, options: options, completionHandler: completionHandler)
    }
    
    /// 打开链接
    ///
    /// - Parameters:
    ///   - url: url
    ///   - isSafe: 会判断 能否打开 | default: true
    ///   - options: UIApplication.OpenExternalURLOptionsKey
    ///   - completionHandler: 完成回调
    func open(url: URL,
              isSafe: Bool = true,
              options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
              completionHandler: ((Bool) -> Void)? = nil) {
        if isSafe, !UIApplication.shared.canOpenURL(url) { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: options, completionHandler: completionHandler)
        } else {
            // https://stackoverflow.com/questions/19356488/openurl-freezes-app-for-over-10-seconds
            // 解决打开 其他 app 慢
            DispatchQueue.main.async {
                completionHandler?(UIApplication.shared.openURL(url))
            }
        }
    }
    
    
}

