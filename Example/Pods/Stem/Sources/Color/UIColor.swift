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

public extension UIColor {

    /// 随机色
    static var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: 1)
    }

    /// 设置透明度
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: uicolor
    func with(alpha: CGFloat) -> UIColor { return self.withAlphaComponent(alpha) }

    /// 获取RGB色值
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            return (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }


}

public extension UIColor{


    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(str: String){
        var cString = str.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("0X") { cString = String(cString.dropFirst(2)) }
        if cString.hasPrefix("#") { cString = String(cString.dropFirst(1)) }
        if cString.count != 6 {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }

        var r: UInt32 = 0x0
        Scanner(string: String(cString)).scanHexInt32(&r)
        self.init(value: UInt(r))
    }

    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(sRGB str: String){
        var cString = str.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("0X") { cString = String(cString.dropFirst(2)) }
        if cString.hasPrefix("#") { cString = String(cString.dropFirst(1)) }
        if cString.count != 6 {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }

        var r: UInt32 = 0x0
        Scanner(string: String(cString)).scanHexInt32(&r)
        self.init(sRGB: UInt(r))
    }


    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(value: UInt) {
        self.init(r: CGFloat((value & 0xFF0000) >> 16),
                  g: CGFloat((value & 0x00FF00) >> 8),
                  b: CGFloat(value & 0x0000FF))
    }

    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(sRGB value: UInt) {
        self.init(sRGB: CGFloat((value & 0xFF0000) >> 16),
                  g: CGFloat((value & 0x00FF00) >> 8),
                  b: CGFloat(value & 0x0000FF))
    }


    /// 设置RGBA颜色
    ///
    /// - Parameters:
    ///   - r: red    0 - 255
    ///   - g: green  0 - 255
    ///   - b: blue   0 - 255
    ///   - a: alpha  0 - 255
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }

    /// 设置sRGB RGBA颜色
    ///
    /// - Parameters:
    ///   - r: red    0 - 255
    ///   - g: green  0 - 255
    ///   - b: blue   0 - 255
    ///   - a: alpha  0 - 255
    convenience init(sRGB r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: r / 255, green: g / 255, blue: b / 255, alpha: a)
        } else {
            self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
        }
    }

}
