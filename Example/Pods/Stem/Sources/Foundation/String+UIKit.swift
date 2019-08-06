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

extension String: StemCompatible { }

public extension Stem where Base == String {
    
    /// 解析HTML样式
    ///
    /// https://github.com/Luur/SwiftTips#57-render-html-within-a-uilabel
    ///
    /// - Parameters:
    ///   - fontName: 字体名称
    ///   - fontSize: 字体大小
    ///   - colorHex: 字体颜色
    /// - Returns: 富文本
    func htmlAttributedString(font: UIFont, color hex: String) -> NSAttributedString? {
        do {
            let cssPrefix = "<style>* { font-family: \(font.fontName); color: #\(hex); font-size: \(font.pointSize); }</style>"
            let html = cssPrefix + base
            guard let data = html.data(using: String.Encoding.utf8) else {  return nil }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    /// 获取字符串的Bounds
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    func bounds(attributes: [NSAttributedString.Attribute], size: CGSize, option: NSStringDrawingOptions = []) -> CGRect {
        if base.isEmpty { return CGRect.zero }
        return base.boundingRect(with: size, options: option, attributes: attributes.attributes, context: nil)
    }
    
    /// 获取字符串的CGSize
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    func size(attributes: [NSAttributedString.Attribute],
              size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                    height: CGFloat.greatestFiniteMagnitude),
              option: NSStringDrawingOptions = []) -> CGSize {
        return self.bounds(attributes: attributes, size: size, option: option).size
    }
    
    /// 文本行数
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 行数
    func rows(font: UIFont, width: CGFloat) -> CGFloat {
        if base.isEmpty { return 0 }
        // 获取单行时候的内容的size
        let singleSize = (base as NSString).size(withAttributes: [NSAttributedString.Key.font:font])
        // 获取多行时候,文字的size
        let textSize = self.size(attributes: [NSAttributedString.Attribute.font(font)],
                                 size: CGSize(width: width,
                                              height: CGFloat.greatestFiniteMagnitude))
        // 返回计算的行数
        return ceil(textSize.height / singleSize.height)
    }
    
}






public extension Stem where Base == String {
    
    ///  获取富文本类型字符串
    ///
    /// - Parameter attributes: 富文本属性
    /// - Returns: 富文本类型字符串
    func attributes(_ attributes: NSAttributedString.Attribute...) -> NSAttributedString {
        return NSAttributedString(string: base, attributes: attributes)
    }
    
    ///  获取富文本类型字符串
    ///
    /// - Parameter attributes: 富文本属性
    /// - Returns: 富文本类型字符串
    func attributes(_ attributes: [NSAttributedString.Attribute]) -> NSAttributedString {
        return NSAttributedString(string: base, attributes: attributes)
    }
    
}


