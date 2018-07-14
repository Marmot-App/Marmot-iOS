//
//  BLFoundation
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

import Foundation

public extension Double {
  /// Double转Int
  public var int: Int { return Int(self) }
  /// Double转String
  public var string: String { return String(self) }
  /// Double转Float
  public var float: Float { return Float(self) }
  /// 绝对值
  public var abs: Double { return Swift.abs(self) }
}

// MARK: - format
public extension Double{
  /// 四舍五入
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func round(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.round(self * divisor) / divisor
  }

  /// 向上取整
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func ceil(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.ceil(self * divisor) / divisor
  }

  /// 向下取整
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func floor(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.floor(self * divisor) / divisor
  }

  /// 中国区价格类型
  public var price: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "ii_CN")
    return formatter.string(from: self as NSNumber)!
  }

  /// 当地价格类型
  public var localePrice: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter.string(from: self as NSNumber)!
  }
}
