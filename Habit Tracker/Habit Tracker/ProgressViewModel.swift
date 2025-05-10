

//  ProgressViewModel.swift
//  Habit Tracker
//
//  Created by Wong Wilson on 9/5/2025.
//
import Foundation
import SwiftUI
import Combine

class ProgressViewModel : ObservableObject{
    @Published var selectedMonth: Int
    @Published var selectedYear: Int
    @Published var currentDate = Date()
    @Published var daysInMonth: [Date] = []
    @Published var completedDays: Set<String> = []
    //stats
    @Published var currentStreak: Int = 0
     @Published var longestStreak: Int = 0
     @Published var completionRate: Double = 0.0
     @Published var monthlyPoints: Int = 0
    
    private var HabitViewModel : HabitViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(habitViewModel: HabitViewModel){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: Date())
        
        self.selectedMonth = components.month ?? 1
        self.selectedYear = components.year ?? 2025
        self.HabitViewModel = habitViewModel
        //Load Initial data
        self.generateDaysForSelectedMonth()
        self.loadCompletedDays()
        habitViewModel.$habits
        
            .sink { [weak self] habits in
                self?.calculateStats()
              
            }
        
            .store(in: &cancellables)
        
        //calculate intial stats
        self.calculateStats()
    }
    
    func generateDaysForSelectedMonth() {
        daysInMonth.removeAll()
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.month = selectedMonth
        dateComponents.year = selectedYear
        dateComponents.day = 1
        
        
        //get the first day of the month
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else { return }
        
        //Calculate start of first week to get proper grid alignment
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let weekdayOffset = (firstWeekday + 5) % 7 // Adjusting for Monday as first day (1)
        if weekdayOffset > 0 {
                    // Add days from previous month to fill the first week
                    for i in 0..<weekdayOffset {
                        if let date = calendar.date(byAdding: .day, value: -weekdayOffset + i, to: firstDayOfMonth) {
                            daysInMonth.append(date)
                        }
                    }
                }
        
        // get the range of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {return}
        
        // generate all days in the mont
        for day in range {
                    dateComponents.day = day
                    if let date = calendar.date(from: dateComponents) {
                        daysInMonth.append(date)
                    }
                }
        }
        
    func previousMonth(){
        if selectedMonth == 1 {
            selectedMonth = 12
            selectedYear -= 1
        }else {
            selectedMonth -= 1
        }
        generateDaysForSelectedMonth()
        loadCompletedDays()
        calculateStats()
        
    }
    
    func nextMonth(){
        if selectedMonth == 12 {
            selectedMonth = 1
            selectedYear += 1
        }else {
            selectedMonth += 1
        }
        generateDaysForSelectedMonth()
        loadCompletedDays()
        calculateStats()
    }
    
    func isDateToday(_ date: Date) -> Bool {
            return Calendar.current.isDate(date, inSameDayAs: Date())
        }
        
        func dateString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    func monthYearString() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM yyyy"
           
           var components = DateComponents()
           components.month = selectedMonth
           components.year = selectedYear
           
           if let date = Calendar.current.date(from: components) {
               return dateFormatter.string(from: date)
           }
           
           return "Unknown"
       }
    func toggleCompletionForDate(_ date: Date) {
            let dateStr = dateString(from: date)
            
            if completedDays.contains(dateStr) {
                completedDays.remove(dateStr)
            } else {
                completedDays.insert(dateStr)
            }
            
            saveCompletedDays()
            calculateStats()
        }
    
    func isDateCompleted(_ date: Date) -> Bool {
            return completedDays.contains(dateString(from: date))
        }
        
        private func loadCompletedDays() {
            if let data = UserDefaults.standard.object(forKey: "CompletedDays") as? Data,
               let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                completedDays = decoded
            }
        }
        
        private func saveCompletedDays() {
            if let encoded = try? JSONEncoder().encode(completedDays) {
                UserDefaults.standard.set(encoded, forKey: "CompletedDays")
            }
        }
    private func calculateStats() {
        
    }
    private func calculateMonthlyPoints(habits: [Habit]) {
        // Calculate points based on completed habits and their difficulty
        var points = 0
        
        for habit in habits {
            // Count how many times this habit was completed this month
            let completionsThisMonth = daysInMonth.filter { date in
                // If the date is completed and it's a day this habit should be done
                let dayOfWeek = getDayOfWeek(from: date)
                return isDateCompleted(date) && habit.frequency.contains(dayOfWeek)
            }.count
            
            // Calculate points based on difficulty
            let habitPoints: Int
            switch habit.difficulty {
            case "Easy":
                habitPoints = 50
            case "Medium":
                habitPoints = 100
            case "Hard":
                habitPoints = 150
            default:
                habitPoints = 0
            }
            
            points += completionsThisMonth * habitPoints
        }
    }
    private func getDayOfWeek(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Full day name
            return formatter.string(from: date)
        }
    
    
    
}

