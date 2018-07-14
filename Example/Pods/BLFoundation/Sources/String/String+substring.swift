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

// MARK: - 索引
extension String {
  /// 获取指定字符串第一个字符在母串中的索引
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 索引
  func index(first str: String) -> String.Index? {
    let range = self.range(of: str)
    return range?.lowerBound
  }

  /// 获取指定字符串最后一个字符在母串中的索引
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 索引
  func index(last str: String) -> String.Index? {
    let range = self.range(of: str)
    return range?.upperBound
  }
}

// MARK: - 下标/区间截取
public extension String {
  /// 获取指定位置字符
  ///
  /// - Parameter index: 指定位置
  subscript(index: Int) -> String {
    if index < 0 || index >= count { return "" }
    let index = self.index(startIndex, offsetBy: String.IndexDistance(index))
    return String(self[index])
  }

  /// 截取: 区间内的子串
  ///
  /// - Parameter closedRange: 区间
  subscript(integerRange: Range<Int>) -> String {
    if isEmpty { return "" }
    var range: (start: Int, end: Int) = (integerRange.lowerBound,integerRange.upperBound)
    if range.start < 0 { range.start = 0 }
    if range.end >= count { range.end = count }
    if range.start > range.end { return "" }
    if range.start == range.end { return "" }
    let start = index(startIndex, offsetBy: range.start)
    let end = index(startIndex, offsetBy: range.end)
    return String(self[start..<end])
  }

  /// 截取: 区间内的子串
  ///
  /// - Parameter closedRange: 区间
  subscript(closedRange: CountableClosedRange<Int>) -> String {
    if isEmpty { return "" }
    var range: (start: Int, end: Int) = (closedRange.lowerBound,closedRange.upperBound)
    if range.start < 0 { range.start = 0 }
    if range.end >= count { range.end = count - 1 }
    if range.start > range.end { return "" }
    if range.start == range.end { return self[range.start] }
    let start = index(startIndex, offsetBy: range.start)
    let end = index(startIndex, offsetBy: range.end)
    return String(self[start...end])
  }
}

// MARK: - 截取
public extension String {

  /// 截取: 获取指定字符串前的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(before str: String) -> String {
    guard let index = self.index(first: str) else { return "" }
    return String(self[..<index])
  }

  /// 截取: 获取指定字符串后的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(after str: String) -> String {
    guard let index = self.index(last: str) else { return "" }
    let str = String(self[index...])
    return str
  }
}
