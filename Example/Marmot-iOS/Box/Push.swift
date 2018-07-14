//
//  Push.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/13.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AnyFormatProtocol
import UserNotifications
import CoreLocation


class PushHelper: NSObject, UNUserNotificationCenterDelegate {
  
  // 对通知进行响应
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    // 根据类别标识符处理目标反应
    if response.notification.request.content.categoryIdentifier == "categoryIndentifier" {
      let actionIndentifier = response.actionIdentifier
      /// 处理留言
      if  actionIndentifier == "commitIndentifier",let input = response as? UNTextInputNotificationResponse {
        print(input.userText)
      }
      else if  actionIndentifier == "inputIndentifier",let input = response as? UNTextInputNotificationResponse {
        print(input.userText)
      }else{
        
      }
    }
    
    completionHandler()
  }
  
  // 如果在应用内展示通知 （如果不想在应用内展示，可以不实现这个方法）
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert,.badge,.sound])
  }
  
}


@objc(Router_push)
class Router_push: NSObject,AnyFormatProtocol {
  
  static var isRegist = false
  var pushHelper = PushHelper()
  
  func regist() {
    if Router_push.isRegist { return }
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      center.delegate = pushHelper
      center.requestAuthorization(options: [.alert,.badge,.carPlay,.sound]) { (res, err) in
        Router_push.isRegist = res
      }
    }else{
      let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
      Router_push.isRegist = true
    }
  }
  
  @objc func router_schedule(params:[String: Any]) -> [String: Any] {
    regist()
    let id = String(describing: params.description.hashValue)
    var query: [String : Any] = format(params["query"])
    query["id"] = id
    if #available(iOS 10.0, *)  {
      let content = UNMutableNotificationContent()
      content.badge = format(params["badge"]) as Int as NSNumber
      content.body = format(params["body"])
      content.title = format(params["title"])
      // content.sound = UNNotificationSound.init(named: <#T##String#>)
      content.subtitle = format(params["subtitle"])
      content.userInfo = query
      content.launchImageName = "logo.png"
      
      var trigger: UNNotificationTrigger?
      let isRepeats: Bool = format(params["isRepeats"])
      
      if params.keys.contains("date") || params.keys.contains("delay") {
        // 时间触发器
        if let dateStr = params["date"] as? String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
          
          guard let date = dateFormatter.date(from: dateStr) else { return ["error": "date 格式错误:\(dateStr)"] }
          let delay = Date(timeIntervalSinceNow: 0).timeIntervalSince(date)
          guard delay >= 0 else { return ["error": "date 距离现在 \(delay)s"] }
          trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: isRepeats)
          
        }else if let delay = params["delay"] as? Double {
          guard delay >= 0 else { return ["error": "date 距离现在 \(delay)s"] }
          trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: isRepeats)
          
        }else{
          return ["error": "date | delay,参数格式错误"]
        }
      }else if false {
        /// 日期触发器
        //每周一早上 8：00 触发
        let components = DateComponents()
        // components.weekday = 2
        // components.hour = 8
        trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: isRepeats)
      }else if let regionDict = params["region"] as? [String: Any] {
        /// 地理位置触发器
        guard let lat = regionDict["lat"] as? Double,
          let lng = regionDict["lng"] as? Double,
          let radius = regionDict["radius"] as? Double
          else { return ["error": "lat | lng | radius,参数格式错误"] }
        //需导入定位库 import CoreLocation
        //距离(lat, lng）点 radius 米 处发起通知
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                      radius: radius,
                                      identifier: "regionidentifier")
        region.notifyOnExit = format(regionDict["notifyOnExit"])
        region.notifyOnEntry = format(regionDict["notifyOnEntry"])
        trigger = UNLocationNotificationTrigger(region: region, repeats: isRepeats)
      }
      
      let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }else {
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
      // 设置一些额外的信息
      note.userInfo = query
      // 2.执行通知
      UIApplication.shared.scheduleLocalNotification(note)
    }
    return ["id": id]
  }
  
  /// 取消计划内的推送消息
  @objc func router_cancel(params:[String: Any]) {
    let title: String = format(params["title"])
    let body: String = format(params["body"])
    let id: String = format(params["id"])
    
    if #available(iOS 10.0, *)  {
      UNUserNotificationCenter.current().getDeliveredNotifications { (item) in
        let list = item.filter { (item) -> Bool in
          return (item.request.content.title == title) || title.isEmpty
          }.filter({ (item) -> Bool in
            return (item.request.content.body == body) || body.isEmpty
          }).filter({ (item) -> Bool in
            return ((item.request.identifier) == id) || id.isEmpty
          }).map({ (item) -> String in
            return item.request.identifier
          })
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: list)
      }
    }else{
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
}

extension AppDelegate {
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    print(#function)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    print(#function)
    
  }
  
  /// app处于前台 / app处于后台时
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    print(#function)
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(#function)
    
  }
  
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
    print(#function)
    
  }
  
}
