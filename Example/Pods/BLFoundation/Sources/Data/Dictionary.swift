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

public extension Dictionary {

  /// 根据下标集合获取元素集合
  ///
  /// - Parameter keys: 下标集合
  public subscript(keys: [Key]) -> [Value] {
    let values = keys.flatMap { (key) -> Value? in
      return self[key]
    }
    return values
  }

}

public extension Dictionary {
  /// 从字典中随机取值
  ///
  /// - Returns: 值
  public var random: Value? {
    get{
      if isEmpty { return nil }
      let index: Int = Int(arc4random_uniform(UInt32(self.count)))
      return Array(self.values)[index]
    }
  }

  /// 检查是否有值
  ///
  /// - Parameter key: key名
  /// - Returns: 是否
  public func has(key: Key) -> Bool {
    return index(forKey: key) != nil
  }

  /// 更新字典
  ///
  /// - Parameter dicts: 单个/多个字典
  /// - Returns: 新字典
  public mutating func update(dicts: Dictionary...) {
    dicts.forEach { (dict) in
      dict.forEach({ (item) in
        self.updateValue(item.value, forKey: item.key)
      })
    }
  }

  /// 格式化为Json
  ///
  /// - Returns: Json字符串
  public func formatJSON(prettify: Bool = false) -> String {
    guard JSONSerialization.isValidJSONObject(self) else {
      return "{}"
    }
    let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
      return String(data: jsonData, encoding: .utf8) ?? "{}"
    } catch {
      return "{}"
    }
  }

}
