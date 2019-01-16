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


// MARK: - Dictionary 重载操作符
extension Dictionary {
  
  /// 两个字典相加
  ///
  /// - Parameters:
  ///   - lhs: 左侧字典
  ///   - rhs: 右侧字典
  /// - Returns: 返回新的字典
  static func +(lhs: Dictionary,rhs: Dictionary) -> Dictionary {
    var temp = Dictionary()
    lhs.forEach { temp.updateValue($0.value, forKey: $0.key) }
    rhs.forEach { temp.updateValue($0.value, forKey: $0.key) }
    return temp
  }
  
}

// MARK: - Dictionary subscript函数
public extension Dictionary {
  
  /// 根据下标集合获取元素集合
  ///
  /// - Parameter keys: 下标集合
  public subscript(_ keys: [Key]) -> [Value] {
    return keys.compactMap {  self[$0] }
  }
  
  
  /// 根据下标集合获取元素集合
  ///
  /// - Parameter keys: 下标集合
  public subscript(_ keys: Key...) -> [Value] {
    return keys.compactMap {  self[$0] }
  }
  
}

// MARK: - Dictionary 属性
public extension Dictionary {
  /// 从字典中随机取值
  ///
  /// - Returns: 值
  public var random: (key: Key,value: Value)? {
    guard let key = keys.randomElement(), let value = self[key] else { return nil }
    return (key: key,value: value)
  }
  
}

// MARK: - 函数
public extension Dictionary {
  /// 检查是否有值
  ///
  /// - Parameter key: key名
  /// - Returns: 是否
  public func has(key: Key) -> Bool {
    return index(forKey: key) != nil
  }
  
  /// 格式化为Json
  ///
  /// - Returns: Json字符串
  public func formatJSON(prettify: Bool = false) -> String {
    guard JSONSerialization.isValidJSONObject(self) else { return "{}" }
    let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
      return String(data: jsonData, encoding: .utf8) ?? "{}"
    } catch {
      return "{}"
    }
  }
  
}
