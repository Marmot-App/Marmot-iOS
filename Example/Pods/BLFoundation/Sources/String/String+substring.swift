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

// MARK: - 下标/区间截取
public extension String {
  /// 获取指定位置字符
  ///
  ///     let str = "1234567890"
  ///     print(str[0])
  ///     // Print 1
  ///     print(str[20])
  ///     // Print nil
  ///     print(str[-10])
  ///     // Print nil
  ///
  /// - Parameter index: 指定位置
  subscript(_ index: Int) -> String? {
    if index < 0 || index >= count { return nil }
    let index = self.index(startIndex, offsetBy: String.IndexDistance(index))
    return String(self[index])
  }
  
  /// 安全截取: 闭区间内的子串
  ///
  ///     let str = "1234567890"
  ///     print(str[3...6])
  ///     // Print "4567"
  ///     print(str[0...5])
  ///     // Print "123456"
  ///     print(str[-10...100])
  ///     // Print "1234567890"
  ///
  /// - Parameter range: 闭区间
  subscript(_ range: CountableClosedRange<Int>) -> String {
    if isEmpty { return "" }
    var range: (start: Int, end: Int) = (range.lowerBound,range.upperBound)
    if range.start < 0 { range.start = 0 }
    if range.end >= count { range.end = count - 1 }
    if range.start > range.end { return "" }
    if range.start == range.end { return "" }
    let start = index(startIndex, offsetBy: range.start)
    let end = index(startIndex, offsetBy: range.end)
    return String(self[start...end])
  }

  /// 安全截取: 闭区间内的子串
  ///
  ///     let str = "1234567890"
  ///     print(str[0..<5])
  ///     // Print "12345"
  ///     print(str[0...20])
  ///     // Print "1234567890"
  ///     print(str[-10...0])
  ///     // Print ""
  ///
  /// - Parameter range: 区间
  subscript(_ range: CountableRange<Int>) -> String {
    return String(self[range.lowerBound...(range.upperBound - 1)])
  }

  /// 安全截取: 闭区间内的子串
  ///
  ///     let str = "1234567890"
  ///     print(str[5...])
  ///     // Print "67890"
  ///     print(str[20...])
  ///     // Print ""
  ///
  /// - Parameter range: 区间
  subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
    return String(self[range.lowerBound...(self.count - 1)])
  }
  
  /// 安全截取: 闭区间内的子串
  ///
  ///     let str = "1234567890"
  ///     print(str[..<5])
  ///     // Print "12345"
  ///     print(str[..<20])
  ///     // Print "1234567890"
  ///
  /// - Parameter range: 区间
  subscript(_ range: PartialRangeUpTo<Int>) -> String {
    return String(self[0..<range.upperBound])
  }
  
  /// 安全截取: 闭区间内的子串
  ///
  ///     let str = "1234567890"
  ///     print(str[...5])
  ///     // Print "123456"
  ///     print(str[5...])
  ///     // Print "67890"
  ///     print(str[-10...])
  ///     // Print "1234567890"
  ///
  /// - Parameter range: 区间
  subscript(_ range: PartialRangeThrough<Int>) -> String {
    return String(self[0...range.upperBound])
  }
  
}

// MARK: - 截取
public extension String {
  /// 截取: 获取指定字符串前的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(before str: String) -> String {
    return self.components(separatedBy: str).first ?? ""
  }
  
  /// 截取: 获取指定字符串后的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(after str: String) -> String {
    return self.components(separatedBy: str).last ?? ""
  }
}
