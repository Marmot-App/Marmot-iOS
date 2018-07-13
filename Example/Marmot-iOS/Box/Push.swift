//
//  Push.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/13.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AnyFormatProtocol

@objc(Router_push)
class Router_push: NSObject,AnyFormatProtocol {
  
  @objc func router_schedule(params:[String: Any]) -> [String: Any] {
    // 创建本地通知
    let note = UILocalNotification()
    // 设置通知发送的时间
    
    if params.keys.contains("date") {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      note.fireDate = dateFormatter.date(from: format(params["date"]))
    }else if params.keys.contains("delay") {
      let date = Date(timeIntervalSinceNow: format(params["delay"]))
      note.fireDate = date
    }
    
    if #available(iOS 8.2, *), params.keys.contains("title") {
      note.alertTitle = format(params["title"])
    }
    // 设置通知内容
    note.alertBody = format(params["body"])
    // 设置通过到来的声音
    note.soundName = UILocalNotificationDefaultSoundName
    // 设置应用图标左上角显示的数字
    note.applicationIconBadgeNumber = format(params["badge"])
    
    let id = String(describing: params.description.hashValue)
    // 设置一些额外的信息
    note.userInfo = format(params["query"])
    note.userInfo?["id"] = id
    // 2.执行通知
    UIApplication.shared.scheduleLocalNotification(note)
    return ["id": id]
  }
  
  /// 取消计划内的推送消息
  @objc func router_cancel(params:[String: Any]) {
    let title: String = format(params["title"])
    let body: String = format(params["body"])
    let id: String = format(params["id"])
    UIApplication.shared.scheduledLocalNotifications?.filter { (item) -> Bool in
      if #available(iOS 8.2, *) {
        return (item.alertTitle == title) || title.isEmpty
      } else {
        return true
      }
      }.filter({ (item) -> Bool in
        return (item.alertBody == body) || body.isEmpty
      }).filter({ (item) -> Bool in
        return ((item.userInfo?["id"] as? String ?? "") == id) || id.isEmpty
      }).forEach { (item) in
        UIApplication.shared.cancelLocalNotification(item)
    }
  }
}

extension AppDelegate {
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    
  }
  
  /// app处于前台 / app处于后台时
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    
  }
  
}
