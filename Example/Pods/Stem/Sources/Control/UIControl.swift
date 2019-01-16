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

// MARK: - runtime keys
extension UIControl {
  
  private static let swizzing: Void = {
    StemRuntime.exchangeMethod(selector: #selector(UIControl.sendAction(_:to:for:)),
                               replace: #selector(UIControl.st_sendAction(action:to:forEvent:)),
                               class: UIControl.self)
    
  }()
  
  private struct ActionKey {
    static var action = UnsafeRawPointer(bitPattern: "uicontrol_action_block".hashValue)
    static var time = UnsafeRawPointer(bitPattern: "uicontrol_event_time".hashValue)
    static var interval = UnsafeRawPointer(bitPattern: "uicontrol_event_interval".hashValue)
  }
}


public extension UIControl {
  
  /// 添加响应事件
  ///
  /// - Parameters:
  ///   - event: 响应事件类型
  ///   - action: 响应事件
  public func add(for event: UIControl.Event, action: @escaping () -> ()) {
    guard let selector = selector(event: event) else { return }
    let act = ActionBlock(key: event.rawValue, action: action)
    actionBlocks = actionBlocks.filter { (item) -> Bool in
      return item.key != act.key
    }
    actionBlocks.append(act)
    self.addTarget(self, action: selector, for: event)
  }
  
}



// MARK: - time
extension UIControl {
  
  /// 系统响应事件
  fileprivate var systemActions: [String] {
    return ["_handleShutterButtonReleased:",
            "cameraShutterPressed:",
            "_tappedBottomBarCancelButton:",
            "_tappedBottomBarDoneButton:",
            "recordStart:",
            "btnTouchUp:withEvent:"]
  }
  
  // 重复点击的间隔
  public var eventInterval: TimeInterval {
    get {
      if let eventInterval = objc_getAssociatedObject(self,
                                                      UIControl.ActionKey.interval!) as? TimeInterval {
        return eventInterval
      }
      return 0
    }
    set {
      UIControl.swizzing
      objc_setAssociatedObject(self,
                               UIControl.ActionKey.interval!,
                               newValue as TimeInterval,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  /// 上次事件响应时间
  fileprivate var lastEventTime: TimeInterval {
    get {
      if let eventTime = objc_getAssociatedObject(self, UIControl.ActionKey.time!) as? TimeInterval {
        return eventTime
      }
      return 1.0
    }
    set {
      UIControl.swizzing
      objc_setAssociatedObject(self,
                               UIControl.ActionKey.time!,
                               newValue as TimeInterval,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  @objc fileprivate func st_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
    if systemActions.contains(action.description) || eventInterval <= 0 {
      self.st_sendAction(action: action, to: target, forEvent: event)
      return
    }
    
    let nowTime = Date().timeIntervalSince1970
    if nowTime - lastEventTime < eventInterval { return }
    if eventInterval > 0 { lastEventTime = nowTime }
    self.st_sendAction(action: action, to: target, forEvent: event)
  }
  
}

// MARK: - target
extension UIControl {
  
  fileprivate struct ActionBlock {
    var key: UInt
    var action: ()->()
  }
  
  fileprivate var actionBlocks: [ActionBlock] {
    get { return objc_getAssociatedObject(self,UIControl.ActionKey.action!) as? [ActionBlock] ?? [] }
    set { objc_setAssociatedObject(self,
                                   UIControl.ActionKey.action!,
                                   newValue as [ActionBlock],
                                   .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  fileprivate func triggerAction(for: UIControl, event: UIControl.Event){
    let action = actionBlocks.filter { (item) -> Bool
      in return item.key == event.rawValue
      }.first
    guard let act = action else { return }
    act.action()
  }
  
  fileprivate func selector(event: UIControl.Event) -> Selector? {
    var selector: Selector?
    switch event.rawValue {
    // Touch events
    case 1 << 0: selector = #selector(touchDown(sender:))
    case 1 << 1: selector = #selector(touchDownRepeat(sender:))
    case 1 << 2: selector = #selector(touchDragInside(sender:))
    case 2 << 2: selector = #selector(touchDragOutside(sender:))
    case 2 << 3: selector = #selector(touchDragEnter(sender:))
    case 2 << 4: selector = #selector(touchDragExit(sender:))
    case 2 << 5: selector = #selector(touchUpInside(sender:))
    case 2 << 6: selector = #selector(touchUpOutside(sender:))
    case 2 << 7: selector = #selector(touchCancel(sender:))
    // UISlider events
    case 2 << 11: selector = #selector(valueChanged(sender:))
    // TV event
    case 2 << 12: selector = #selector(primaryActionTriggered(sender:))
    // UITextField events
    case 2 << 15: selector = #selector(editingDidBegin(sender:))
    case 2 << 16: selector = #selector(editingChanged(sender:))
    case 2 << 17: selector = #selector(editingDidEnd(sender:))
    case 2 << 18: selector = #selector(editingDidEndOnExit(sender:))
    // Other events
    case 4095:       selector = #selector(allTouchEvents(sender:))
    case 983040:     selector = #selector(allEditingEvents(sender:))
    case 251658240:  selector = #selector(applicationReserved(sender:))
    case 4026531840: selector = #selector(systemReserved(sender:))
    case 4294967295: selector = #selector(allEvents(sender:))
    default: selector = nil
    }
    return selector
  }
  
  @objc fileprivate func touchDown(sender: UIControl) {
    triggerAction(for: sender, event: .touchDown)
  }
  @objc fileprivate func touchDownRepeat(sender: UIControl) {
    triggerAction(for:sender, event: .touchDownRepeat)
  }
  @objc fileprivate func touchDragInside(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragInside)
  }
  @objc fileprivate func touchDragOutside(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragOutside)
  }
  @objc fileprivate func touchDragEnter(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragEnter)
  }
  @objc fileprivate func touchDragExit(sender: UIControl) {
    triggerAction(for:sender, event: .touchDragExit)
  }
  @objc fileprivate func touchUpInside(sender: UIControl) {
    triggerAction(for:sender, event: .touchUpInside)
  }
  @objc fileprivate func touchUpOutside(sender: UIControl) {
    triggerAction(for:sender, event: .touchUpOutside)
  }
  @objc fileprivate func touchCancel(sender: UIControl) {
    triggerAction(for:sender, event: .touchCancel)
  }
  @objc fileprivate func valueChanged(sender: UIControl) {
    triggerAction(for:sender, event: .valueChanged)
  }
  @objc fileprivate func primaryActionTriggered(sender: UIControl) {
    if #available(iOS 9.0, *) {
      triggerAction(for:sender, event: .primaryActionTriggered)
    }
  }
  @objc fileprivate func editingDidBegin(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidBegin)
  }
  @objc fileprivate func editingChanged(sender: UIControl) {
    triggerAction(for:sender, event: .editingChanged)
  }
  @objc fileprivate func editingDidEnd(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidEnd)
  }
  @objc fileprivate func editingDidEndOnExit(sender: UIControl) {
    triggerAction(for:sender, event: .editingDidEndOnExit)
  }
  @objc fileprivate func allTouchEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allTouchEvents)
  }
  @objc fileprivate func allEditingEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allEditingEvents)
  }
  @objc fileprivate func applicationReserved(sender: UIControl) {
    triggerAction(for:sender, event: .applicationReserved)
  }
  @objc fileprivate func systemReserved(sender: UIControl) {
    triggerAction(for:sender, event: .systemReserved)
  }
  @objc fileprivate func allEvents(sender: UIControl) {
    triggerAction(for:sender, event: .allEvents)
  }
  
}
