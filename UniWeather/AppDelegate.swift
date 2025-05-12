//
//  AppDelegate.swift
//  UniWeather
//
//  Created by Daniil on 28.04.25.
//

import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    static let shared = AppDelegate()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.kuhockovolec.UniWeather.refresh", using: nil) { task in
            if let appRefreshTask = task as? BGAppRefreshTask {
                self.handleAppRefresh(task: appRefreshTask)
            } else {
                print("[DEBUG] Failed to cast task to BGAppRefreshTask. Task type: \(type(of: task))")
                task.setTaskCompleted(success: false)
            }
        }
        
        scheduleAppRefresh()
        
        return true
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        LocationManager.shared.requestLocationUpdateInBackground()
        
        task.setTaskCompleted(success: true)
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.kuhockovolec.UniWeather.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("[DEBUG] Planned background refresh.")
        } catch {
            print("[DEBUG] Failed to plan background task: \(error)")
        }
    }
}
