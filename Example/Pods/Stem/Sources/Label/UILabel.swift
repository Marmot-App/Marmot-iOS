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

// MARK: - runtime and swizzling
fileprivate extension UILabel {
    
    private static let swizzing: Void = {
        StemRuntime.exchangeMethod(selector: #selector(UILabel.drawText(in:)),
                                   replace: #selector(UILabel.st_drawText(in:)),
                                   class: UILabel.self)
    }()
    
    struct SwzzlingKeys {
        static var textInset = UnsafeRawPointer(bitPattern: "label_textInset".hashValue)
    }
}

// MARK: - UILabel 属性扩展
extension UILabel {
    
    /// 调整文字绘制区域
    public var textInset: UIEdgeInsets {
        get{
            if let eventInterval = objc_getAssociatedObject(self, UILabel.SwzzlingKeys.textInset!) as? UIEdgeInsets {
                return eventInterval
            }
            return UIEdgeInsets.zero
        }
        set {
            UILabel.swizzing
            objc_setAssociatedObject(self,
                                     UILabel.SwzzlingKeys.textInset!,
                                     newValue as UIEdgeInsets,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            drawText(in: bounds)
        }
    }
    
    @objc fileprivate func st_drawText(in rect: CGRect) {
        guard  textInset != .zero else { return }
        let rect = CGRect(x: bounds.origin.x + textInset.left,
                          y: bounds.origin.y + textInset.top,
                          width: bounds.size.width - textInset.left - textInset.right,
                          height: bounds.size.height - textInset.top - textInset.bottom)
        st_drawText(in: rect)
    }
    
}

// MARK: - UILabel 函数扩展
public extension Stem where Base: UILabel {
    
    /// 改变字体大小 增加或者减少
    func change(font offSet: CGFloat) {
        base.font = UIFont(name: base.font.fontName, size: base.font.pointSize + offSet)
    }
    
}

