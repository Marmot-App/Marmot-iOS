//
//  Push.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/13.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_push)
class Router_push: NSObject {
  
  @objc func router_schedule(params:[String: Any]) {
    // 创建本地通知
    let note = UILocalNotification()
    // 设置通知发送的时间
    note.fireDate = Date(timeIntervalSinceNow: 5)
    // 设置通知内容
    note.alertBody = "本地推送"
    // 设置锁屏时,字体下方显示的一个文字
    note.alertAction = "看我"
    note.hasAction = true
    // 设置启动图片(通过通知打开的)
    note.alertLaunchImage = "../Documents/1.jpg"
    // 设置通过到来的声音
    note.soundName = UILocalNotificationDefaultSoundName
    // 设置应用图标左上角显示的数字
    note.applicationIconBadgeNumber = 1
    
    // MARK: - 重复触发间隔
    note.repeatInterval = NSCalendar.Unit.second
    // 设置一些额外的信息
    note.userInfo = ["hello" : "how are you", "msg" : "success"]
    // 2.执行通知
    UIApplication.shared.scheduleLocalNotification(note)
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
