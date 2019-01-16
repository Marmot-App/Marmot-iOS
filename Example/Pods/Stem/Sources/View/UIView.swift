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

// MARK: - UIView 原生属性扩展
public extension UIView{
  
  /// 圆角
  public var cornerRadius: CGFloat {
    get{ return self.layer.cornerRadius }
    set{
      self.layer.cornerRadius = newValue
      self.layer.masksToBounds = true
    }
  }
  
  /// 边框宽度
  public var borderWidth: CGFloat {
    get{ return self.layer.borderWidth }
    set{ self.layer.borderWidth = newValue }
  }
  
  /// 边框颜色
  public var borderColor: UIColor  {
    get{
      guard let temp: CGColor = self.layer.borderColor else {
        return UIColor.clear
      }
      return UIColor(cgColor: temp)
    }
    set { self.layer.borderColor = newValue.cgColor }
  }
  
  /// 背景图片
  public var cgImage: UIImage {
    get{
      guard let temp: Any = self.layer.contents else {
        return UIImage()
      }
      return UIImage.init(cgImage: temp as! CGImage)
    }
    set { self.layer.contents = newValue.cgImage }
  }
  
}



// MARK: - UIView 属性扩展
public extension Stem where Base: UIView{
  
  /** 返回视图所在的视图控制器
   
   示例:
   
   ```
   let vc = UIView().st.viewController
   ```
   
   */
  public var viewController: UIViewController? {
    var next:UIView? = base
    repeat{
      if let vc = next?.next as? UIViewController{ return vc }
      next = next?.superview
    }while next != nil
    return nil
  }
  
  /** 视图中层级关系描述
   
   示例:
   
   ```
   <UIView; frame = (15 74; 345 201); autoresize = RM+BM; layer = <CALayer>>
   | <UIView; frame = (8 8; 185 185); autoresize = RM+BM; layer = <CALayer>>
   |    | <UIView; frame = (8 8; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
   |    |    | <UIButton; frame = (8 8; 153 30); opaque = NO; autoresize = RM+BM; layer = <CALayer>>
   |    | <UIView; frame = (8 100.5; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
   | <UIView; frame = (201 8; 136 185); autoresize = RM+BM; layer = <CALayer>>
   |    | <UILabel; frame = (8 8; 120 21); text = 'Label'; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer>
   ```
   
   */
  public var description: String {
    let recursiveDescription = base
      .perform(Selector(("recursiveDescription")))?
      .takeUnretainedValue() as! String
    return recursiveDescription.replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)",
                                                     with: "$1",
                                                     options: .regularExpression)
  }
  
  /** 获取视图显示内容
   
   示例:
   
   ```
   UIImageView(image: UIView().st.snapshot)
   ```
   */
  public var snapshot: UIImage? {
    UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    base.layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
  /// 设置LayerShadow,offset,radius
  public func setShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
    base.layer.shadowColor = color.cgColor
    base.layer.shadowOffset = offset
    base.layer.shadowRadius = radius
    base.layer.shadowOpacity = 1
    base.layer.shouldRasterize = true
    base.layer.rasterizationScale = UIScreen.main.scale
  }
  
}


// MARK: - UIView 函数扩展
public extension Stem where Base: UIView{
  
  
  func snapshotImage(afterUpdates: Bool) -> UIImage? {
   return base.snapshotView(afterScreenUpdates: true)?.st.snapshot
  }
  
  /** 添加子控件
   
   示例:
   
   ```
   let aView = UIView()
   let bView = UIView()
   UIView().st.addSubviews(aView,bView)
   ```
   
   - Parameter subviews: 子控件数组
   */
  
  public func addSubviews(_ subviews: UIView...) {
    subviews.forEach { base.addSubview($0) }
  }
  
  
  /// 移除全部子控件
  public func removeSubviews() {
    base.subviews.forEach{ $0.removeFromSuperview() }
  }
  
  
  /** 添加子控件
   
   示例:
   
   ```
   let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
   let pan = UIPanGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
   UIView().addGestureRecognizers(tap,pan)
   ```
   
   - Parameter subviews: 手势对象数组
   */
  func addGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) {
    gestureRecognizers.forEach { base.addGestureRecognizer($0) }
  }
  
  /// 移除全部手势
  public func removeGestureRecognizers() {
    base.gestureRecognizers?.forEach{ base.removeGestureRecognizer($0) }
  }
  
}
