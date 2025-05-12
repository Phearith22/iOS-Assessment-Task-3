//
//  Habit_TrackerApp.swift
//  Habit Tracker
//
//  Created by Pichsophearith lay on 2/5/2025.
//
 
import SwiftUI
 
@main
struct Habit_TrackerApp: App {
    init() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                print("Notifications permission: \(granted)")
            }
        }
    var body: some Scene {
        WindowGroup {
            SplashView() //should actually start with splashview
            //DashboardView(viewModel: HabitViewModel()) //starting with dashboard view to test
        }
    }
}
 
