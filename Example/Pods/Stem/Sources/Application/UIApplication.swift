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

#if canImport(AVFoundation)
import AVFoundation
public extension Stem where Base: UIDevice {
  
  /// 闪光灯 亮度等级
  public var torchLevel: Double {
    guard let device = AVCaptureDevice.default(for: .video) else { return 0 }
    return Double(device.torchLevel)
  }
  
  /// 开启/关闭 闪光灯
  ///
  /// - Parameter level: 亮度等级 0 ~ 1
  public func torch(level: Double) {
    guard level >= 0, level <= 1, let device = AVCaptureDevice.default(for: .video) else { return }
    do {
      try device.lockForConfiguration()
      if level == 0 {
        device.torchMode = .off
      }else{
        device.torchMode = .on
        try device.setTorchModeOn(level: Float(level))
      }
      device.unlockForConfiguration()
    }catch{
      print(error.localizedDescription)
    }
  }
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter params: level  (number)  0 ~ 3 表示振动等级
  public func taptic(level: Int, isSupportTaptic: Bool = true) {
    if #available(iOS 10.0, *),
      isSupportTaptic,
      let style = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: level) {
      let tapticEngine = UIImpactFeedbackGenerator(style: style)
      tapticEngine.prepare()
      tapticEngine.impactOccurred()
    }else{
      switch level {
      case 3:
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      case 2:
        // 连续三次短震
        AudioServicesPlaySystemSound(1521)
      case 1:
        // 普通短震，3D Touch 中 Pop 震动反馈
        AudioServicesPlaySystemSound(1520)
      default:
        // 普通短震，3D Touch 中 Peek 震动反馈
        AudioServicesPlaySystemSound(1519)
      }
    }
  }
  
}

#endif



public extension UIApplication {
  
  public static let info = Info()
  
  public struct Info {
    /// 获取App版本号
    public let version: String = {
      return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }()
    
    /// 获取App构建版本号
    public let bundleVersion: String = {
      return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }()
  }
  
}


// MARK: - open
public extension Stem where Base: UIApplication {
  
  /// 打开链接 (会判断 能否打开)
  ///
  /// - Parameter url: url
  public func open(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str),
      UIApplication.shared.canOpenURL(url) else{ return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str) else { return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: URL) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  
}

