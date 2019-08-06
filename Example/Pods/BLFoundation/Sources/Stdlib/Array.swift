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
extension Array {
    
    
    /// 安全截取: 闭区间内的子串
    ///
    /// - Parameter range: 闭区间
    public func slice(_ range: CountableClosedRange<Int>) -> Array<Element> {
        if isEmpty { return self }
        var range: (start: Int, end: Int) = (range.lowerBound,range.upperBound)
        if range.start < 0 { range.start = 0 }
        if range.end >= count { range.end = count - 1 }
        if range.start > range.end { return [] }
        if range.start == range.end { return [] }
        let start = index(startIndex, offsetBy: range.start)
        let end = index(startIndex, offsetBy: range.end)
        return Array(self[start...end])
    }
    
    /// 安全截取: 闭区间内的子串
    ///
    /// - Parameter range: 区间
    public func slice(_ range: CountableRange<Int>) -> Array<Element> {
        let ran: CountableClosedRange<Int> = range.lowerBound...(range.upperBound - 1)
        return self.slice(ran)
    }
    
    /// 安全截取: 闭区间内的子串
    ///
    /// - Parameter range: 区间
    public func slice(_ range: CountablePartialRangeFrom<Int>) -> Array<Element> {
        let ran: CountableClosedRange<Int> = range.lowerBound...(self.count - 1)
        return self.slice(ran)
    }
    
    /// 安全截取: 闭区间内的子串
    ///
    /// - Parameter range: 区间
    public func slice(_ range: PartialRangeUpTo<Int>) -> Array<Element> {
        let ran: CountableClosedRange<Int> = 0...(range.upperBound - 1)
        return self.slice(ran)
    }
    
    /// 安全截取: 闭区间内的子串
    ///
    /// - Parameter range: 区间
    public func slice(_ range: PartialRangeThrough<Int>) -> Array<Element> {
        let ran: CountableClosedRange<Int> = 0...range.upperBound
        return self.slice(ran)
    }
    
}

// MARK: - Array about remove
extension Array where Element: Equatable {
    
    
    mutating func removeFirst(with object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    mutating func removeLast(with object: Element) {
        if let index = lastIndex(of: object) {
            remove(at: index)
        }
    }
    
    mutating func removeAll(with object: Element) {
        self = filter{ $0 != object }
    }
    
}


public extension Array {
    
    /// 打乱数组
    var shuffled: Array {
        get{
            var result = self
            result.shuffle()
            return result
        }
    }
    
    /// 获取: 指定位置的值
    ///
    /// as python
    /// let list = [0,1,2]
    /// print(list.value(at: 1))
    /// 1
    /// print(list.value(at: -1))
    /// 2
    ///
    /// - Parameter index: 指定序列
    /// - Returns: 值
    func value(at index: Int) -> Element? {
        let rawIndex = index < 0 ? count + index : index
        guard rawIndex < count, rawIndex >= 0 else { return nil }
        return self[rawIndex]
    }
    
    /// 打乱数组
    mutating func shuffle() {
        guard self.count > 1 else { return }
        var j: Int
        for i in 0..<(self.count-2) {
            j = Int(arc4random_uniform(UInt32(self.count - i)))
            if i != i+j { self.swapAt(i, i+j) }
        }
    }
    
    /// 分解数组:元组(第一个元素,余下的数组)
    ///
    /// - Returns: 元组(第一个元素,余下的数组)
    func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]): nil
    }
    
    /// 格式化为Json
    ///
    /// - Returns: Json字符串
    func formatJSON(prettify: Bool = false) -> String {
        guard JSONSerialization.isValidJSONObject(self) else {
            return "[]"
        }
        let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }
    
}


