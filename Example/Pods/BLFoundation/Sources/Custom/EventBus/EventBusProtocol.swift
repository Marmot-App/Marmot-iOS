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


public struct EventBusItem<Key,Value> {
  weak var observer: AnyObject?
  var key: Key
  var block: ((Value) -> Void)?
}

public protocol EventBusKey: Hashable { }

public protocol EventBusProtocol {
  associatedtype EventBusKey: Hashable
  associatedtype EventBusValue
  var events: [EventBusItem<EventBusKey,EventBusValue>] { get set }
  var keySet: Set<EventBusKey> { get set }
}

// MARK: - subscribe / push
public extension EventBusProtocol {
  /// 订阅数据更新
  ///
  /// - Parameters:
  ///   - target: 担保实例
  ///   - key: 订阅数据名
  ///   - event: 数据回调
  public mutating func subscribe(observer: AnyObject, key: EventBusKey, event: @escaping (EventBusValue) -> Void) {
    events.append(EventBusItem(observer: observer, key: key, block: event))
    keySet.update(with: key)
  }
  
  /// 推送数据更新
  ///
  /// - Parameters:
  ///   - key: 订阅数据名
  ///   - value: 推送数据
  public mutating func push(key: EventBusKey, value: EventBusValue) {
    var set = Set<EventBusKey>()
    events = events.filter({ (event) -> Bool in
      guard event.observer != nil else { return false }
      set.update(with: event.key)
      if event.key == key {
        event.block?(value)
      }
      return true
    })
    keySet = set
  }
  
}

// MARK: - remove event
public extension EventBusProtocol {
  
  /// 移除 target 下所有订阅事件
  ///
  /// - Parameter target: 担保 target
  public mutating func remove(observer: AnyObject) {
    var set = Set<EventBusKey>()
    events = events.filter({ (event) -> Bool in
      guard let obs = event.observer else { return false }
      let con = !(obs === observer)
      if con { set.update(with: event.key) }
      return con
    })
    keySet = set
  }
  
  /// 移除 key 所有订阅事件
  ///
  /// - Parameter key: 订阅数据名
  public mutating func remove(key: EventBusKey) {
    var set = Set<EventBusKey>()
    events = events.filter({ (event) -> Bool in
      guard event.observer != nil else { return false }
      let con = !(key == event.key)
      if con { set.update(with: event.key) }
      return con
    })
    keySet = set
  }
  
  /// 移除特定订阅事件
  ///
  /// - Parameters:
  ///   - target: 担保 target
  ///   - key: 订阅数据名
  public mutating func remove(observer: AnyObject, key: EventBusKey) {
    var set = Set<EventBusKey>()
    events = events.filter({ (event) -> Bool in
      guard let obs = event.observer else { return false }
      let con = !(key == event.key) && !(obs === observer)
      if con { set.update(with: event.key) }
      return con
    })
    keySet = set
  }
  
}

