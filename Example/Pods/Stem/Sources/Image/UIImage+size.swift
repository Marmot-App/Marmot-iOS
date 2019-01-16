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


// MARK: - UIImage
public extension Stem where Base: UIImage{
  
  /// 图片尺寸: Bytes
  public var sizeAsBytes: Int
  { return base.jpegData(compressionQuality: 1)?.count ?? 0 }
  
  /// 图片尺寸: KB
  public var sizeAsKB: Int {
    let sizeAsBytes = self.sizeAsBytes
    return sizeAsBytes != 0 ? sizeAsBytes / 1024: 0 }
  
  /// 图片尺寸: MB
  public var sizeAsMB: Int {
    let sizeAsKB = self.sizeAsKB
    return sizeAsBytes != 0 ? sizeAsKB / 1024: 0 }
  
}



// MARK: - UIImage 图片处理
public extension Stem where Base: UIImage{
  
  /// 裁剪对应区域
  ///
  /// - Parameter bound: 裁剪区域
  /// - Returns: 新图
  public func crop(bound: CGRect) -> UIImage {
    let scaledBounds = CGRect(x: bound.origin.x * base.scale,
                              y: bound.origin.y * base.scale,
                              width: bound.size.width * base.scale,
                              height: bound.size.height * base.scale)
    guard let cgImage = base.cgImage?.cropping(to: scaledBounds) else { return base }
    return UIImage(cgImage: cgImage, scale: base.scale, orientation: .up)
  }
  
  /// 返回圆形图片
  public func rounded() -> UIImage {
    return base.st.rounded(radius: base.size.height * 0.5,
                           corners: .allCorners,
                           borderWidth: 0,
                           borderColor: nil,
                           borderLineJoin: .miter)
  }
  
  /// 图像处理: 裁圆
  /// - Parameters:
  /// - radius: 圆角大小
  /// - corners: 圆角区域
  /// - borderWidth: 描边大小
  /// - borderColor: 描边颜色
  /// - borderLineJoin: 描边类型
  /// - Returns: 新图
  public func rounded(radius: CGFloat,
                      corners: UIRectCorner = .allCorners,
                      borderWidth: CGFloat = 0,
                      borderColor: UIColor? = nil,
                      borderLineJoin: CGLineJoin = .miter) -> UIImage {
    var corners = corners
    if corners != UIRectCorner.allCorners {
      var rawValue: UInt = 0
      if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.bottomLeft.rawValue }
      if (corners.rawValue & UIRectCorner.topRight.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.bottomRight.rawValue }
      if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.topLeft.rawValue }
      if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.topRight.rawValue }
      corners = UIRectCorner(rawValue: rawValue)
    }
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    defer { UIGraphicsEndImageContext() }
    
    guard let context = UIGraphicsGetCurrentContext() else { return base }
    let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: -rect.height)
    let minSize = min(base.size.width, base.size.height)
    
    if borderWidth < minSize * 0.5{
      let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: borderWidth))
      
      path.close()
      context.saveGState()
      path.addClip()
      guard let cgImage = base.cgImage else { return base }
      context.draw(cgImage, in: rect)
      context.restoreGState()
    }
    
    if (borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0) {
      let strokeInset = (floor(borderWidth * base.scale) + 0.5) / base.scale
      let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
      let strokeRadius = radius > base.scale / 2 ? CGFloat(radius - base.scale / 2): 0
      let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
      path.close()
      path.lineWidth = borderWidth
      path.lineJoinStyle = borderLineJoin
      borderColor?.setStroke()
      path.stroke()
    }
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image ?? base
  }
  
  
  /// 缩放至指定高度
  ///
  /// - Parameters:
  ///   - toWidth: 高度
  ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
  /// - Returns: 新的图片
  public func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toHeight / base.size.height
    let newWidth = base.size.width * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
    base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  
  /// 缩放至指定宽度
  ///
  /// - Parameters:
  ///   - toWidth: 宽度
  ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
  /// - Returns: 新的图片
  public func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toWidth / base.size.width
    let newHeight = base.size.height * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
    base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
}
