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

private extension UIButton {
  
 private static let swizzing: Void = {
    StemRuntime.exchangeMethod(selector: #selector(UIButton.layoutSubviews),
                               replace: #selector(UIButton.st_layoutSubviews),
                               class: UIButton.self)
  }()

}

// MARK: - UIButton 扩展函数
public extension UIButton {

  /// 设置背景颜色
  ///
  /// - Parameters:
  ///   - color: color
  ///   - forState: Button状态
  public func setBackgroundColor(color: UIColor,for forState: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
    UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.setBackgroundImage(colorImage, for: forState)
  }
  
  

  @objc fileprivate func st_layoutSubviews() {
    st_layoutSubviews()

  }
  
}


// MARK: - UIButton 扩展函数
public extension Stem where Base: UIButton{

  
  /// 文字与图片水平居中
  ///
  /// - Parameter spacing: 图片与文字间距
  public func horizontalCenterTitleAndImage(spacing: CGFloat) {
    let imageSize = base.imageView?.frame.size ?? .zero
    var titleSize = CGSize.zero
    if let label = base.titleLabel, let text = label.text {
      titleSize = (text as NSString).boundingRect(with: base.bounds.size,
                                                  options: [.usesLineFragmentOrigin],
                                                  attributes: [NSAttributedString.Key.font : label.font],
                                                  context: nil).size
    }
    
    let totalWidth = (imageSize.width + titleSize.width + spacing)
    base.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:-(totalWidth - imageSize.width) * 2)
    base.titleEdgeInsets = UIEdgeInsets(top:0, left:-(totalWidth - titleSize.width) * 2,bottom: 0,right: 0)
  }
  
  /// 图片与文字垂直居中
  ///
  /// - Parameter spacing: 图片与文字间距
  public func verticalCenterImageAndTitle(spacing: CGFloat) {
    let imageSize = base.imageView?.frame.size ?? .zero
    var titleSize = CGSize.zero
    if let label = base.titleLabel, let text = label.text {
      titleSize = (text as NSString).boundingRect(with: base.bounds.size,
                                                  options: [.usesLineFragmentOrigin],
                                                  attributes: [NSAttributedString.Key.font : label.font],
                                                  context: nil).size
    }
    
    let totalHeight = imageSize.height + titleSize.height + spacing
    base.imageEdgeInsets = UIEdgeInsets(top: imageSize.height - totalHeight, left: 0, bottom: 0, right: -titleSize.width)
    base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom:titleSize.height - totalHeight, right: 0)
  }
  
}
