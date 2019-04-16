//
//  ViewController.swift
//  Project21
//
//  Created by Emin Roblack on 4/14/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal(in:)))
    
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            
            if granted {
                print("Yay!")
            } else {
                print("NO!")
            }
        }
    }
    
    @objc func scheduleLocal(in time: Double) {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wakeup Call"
        content.body = "You really do need to wakeup"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me More", options: .foreground)
        let reveal = UNNotificationAction(identifier: "delay", title: "Delay till Tomorrow", options: .authenticationRequired)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reveal], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom Data recieved \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                print ("Show more Information")
            case "delay":
                print ("Delayed")
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: response.notification.request.content,
                                                    trigger: trigger)
                center.add(request)
            default:
                break
            }
        }
        completionHandler()
    }
}

