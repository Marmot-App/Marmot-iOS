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


// MARK: - Int
public extension Int {
  /// 绝对值
  public var abs: Int { return Swift.abs(self) }
  /// 检查: 是否为偶数
  public var isEven: Bool { return (self % 2 == 0) }
  /// 检查: 是否为奇数
  public var isOdd: Bool { return (self % 2 != 0) }
  /// 检查: 是否为正数
  public var isPositive: Bool { return (self > 0) }
  /// 检查: 是否为负数
  public var isNegative: Bool { return (self < 0) }
  /// 转换: Double.
  public var double: Double { return Double(self) }
  /// 转换: Float.
  public var float: Float { return Float(self) }
  /// 转换: String.
  public var string: String { return String(self) }
  /// 转换: Bool.
  public var bool: Bool { return self == 0 ? false: true }
  /// 转换: UInt.
  public var uint: UInt { return UInt(self) }
  /// 转换: Int32.
  public var int32: Int32 { return Int32(self) }
  /// 转换: Range: 0..<Int
  public var range: CountableRange<Int> { return 0..<self }

  /// 计算: 位数
  public var digits: Int {
    if self == 0 {
      return 1
    } else if Int(fabs(Double(self))) <= LONG_MAX {
      return Int(log10(fabs(Double(self)))) + 1
    } else {
      return -1
    }
  }

}

// MARK: - Int func
public extension Int {

 /// 随机值
 ///
 /// - Parameter range: 范围
 /// - Returns: 随机值
 public static func random(in range: ClosedRange<Int>) -> Int{
    let count = UInt32(range.upperBound - range.lowerBound + 1)
    return Int(arc4random_uniform(count))
  }

  /// 执行self次回调
  ///
  /// - Parameter callback: 回调
  public func times(closure: (Int)->()) {
    if self.isNegative { return }
    for index in 0..<self{ closure(index) }
  }

  /// 执行self次回调
  ///
  /// - Parameter callback: 回调
  public func times(closure: @escaping () -> ()) {
    if self.isNegative { return }
    for _ in 0..<self { closure() }
  }

}

// MARK: - UInt
public extension UInt {
  /// 转换: Int
  public var int: Int { return Int(self) }
  /// 转换: String.
  public var string: String { return String(self) }
}
