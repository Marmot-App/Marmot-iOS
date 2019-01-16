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


/* 协议继承关系
 https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md
                +-------------+   +-------------+
         +------>+   Numeric   |   | Comparable  |
         |       |   (+,-,*)   |   | (==,<,>,...)|
         |       +------------++   +---+---------+
         |                     ^       ^
 +-------+------------+        |       |
 |    SignedNumeric   |      +-+-------+-----------+
 |     (unary -)      |      |    BinaryInteger    |
 +------+-------------+      |(words,%,bitwise,...)|
 ^                    ++---+-----+----------+
 |         +-----------^   ^     ^---------------+
 |         |               |                     |
 +------+---------++    +---------+---------------+  +--+----------------+
 |  SignedInteger  |    |  FixedWidthInteger      |  |  UnsignedInteger  |
 |                 |    |(endianness,overflow,...)|  |                   |
 +---------------+-+    +-+--------------------+--+  +-+-----------------+
                 ^        ^                    ^       ^
                 |        |                    |       |
                 |        |                    |       |
                 ++--------+-+                +-+-------+-+
                 |Int family |-+              |UInt family|-+
                 +-----------+ |              +-----------+ |
                 +-----------+                +-----------+
 */


import Foundation

public extension Numeric {
  /// 转换: String.
  public var string: String { return String(describing: self) }
}

// MARK: - Int family
public extension SignedInteger where Self: SignedInteger {
  /// 绝对值
  public var abs: Self { return Swift.abs(self) }
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

  /// 转换: Bool.
  public var bool: Bool { return self == 0 ? false: true }

  /// 计算: 位数
  public var digits: Int {
    guard self != 0 else { return 1 }
    guard Int(fabs(Double(self))) > LONG_MAX else { return -1 }
    return Int(log10(fabs(Double(self)))) + 1
  }

}


// MARK: - UInt family
public extension UnsignedInteger where Self: SignedInteger {
  
  /// 绝对值
  public var abs: Self { return Swift.abs(self) }
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
  /// 转换: Bool.
  public var bool: Bool { return self == 0 ? false: true }
  
  /// 计算: 位数
  public var digits: Int {
    guard self != 0 else { return 1 }
    guard Int(fabs(Double(self))) > LONG_MAX else { return -1 }
    return Int(log10(fabs(Double(self)))) + 1
  }
  
}
