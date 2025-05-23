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
    @Published var daysInMonth: [Date] = []
    @Published var completedDays: Set<String> = [] // tracks completed dates
    

    //stats
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var completionRate: Double = 0.0
    @Published var monthlyPoints: Int = 0
    
    private var habitViewModel: HabitViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(habitViewModel: HabitViewModel){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: Date())
        
        self.selectedMonth = components.month ?? 1
        self.selectedYear = components.year ?? 2025
        self.habitViewModel = habitViewModel
        //Load Initial data
        loadCompletedDays()
        
        habitViewModel.$habits
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.generateDaysForSelectedMonth()
                self?.calculateStats()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        //calculate intial stats
        generateDaysForSelectedMonth()
        calculateStats()
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
        
        let reminaingDays = (7 - (daysInMonth.count % 7)) % 7
        if reminaingDays > 0 {
            let lastDay = daysInMonth.last ?? firstDayOfMonth
            for i in 1...reminaingDays{
                if let date = calendar.date(byAdding: .day, value: i, to: lastDay) {
                    daysInMonth.append(date)
                }
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
    
    // Get habits scheduled for a specific date
    func habitsForDate(_ date: Date) -> [Habit] {
        let dayName = getDayOfWeek(from: date)
        return habitViewModel.habits.filter { habit in
            habit.frequency.contains(dayName)
        }
    }
    
    // Calculate completion status for a date (0 = none, 0.5 = partial, 1 = complete)
    func completionStatusForDate(_ date: Date) -> Double {
        let dateStr = dateString(from: date)
        let habits = habitsForDate(date)
        
        if habits.isEmpty {
            return 0.0
        }
        let completed = habits.filter { habit in
            habitViewModel.habitCompletions[dateStr]?.contains(habit.id) == true
        }.count

        return Double(completed) / Double(habits.count)
    }
    
    // Check if a specific habit is completed on a date
    func isHabitCompletedOnDate(_ habit: Habit, date: Date) -> Bool {
    habitViewModel.isHabitCompletedOnDate(habit, date: date)
}
    
    // Toggle a habit's completion for a specific date
    func toggleHabitCompletion(_ habit: Habit, date: Date) {
        habitViewModel.toggleHabitCompletion(habit, date: date)
        calculateStats()
        DispatchQueue.main.async {
                self.objectWillChange.send()
            }
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

    func calculateStats() {
        //Calculate all stats
        autoUpdateCompletedDays()
        calculateStreaks()
        calculateCompletionRate()
        calculateMonthlyPoints()
    }
    
    private func calculateStreaks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        var currentCount = 0
        var maxCount = 0

           while true {
               let dateStr = dateString(from: currentDate)
               let habits = habitsForDate(currentDate)

               let allCompleted = !habits.isEmpty && habits.allSatisfy { habit in
                   habitViewModel.habitCompletions[dateStr]?.contains(habit.id) == true
               }

               if allCompleted {
                   currentCount += 1
                   maxCount = max(maxCount, currentCount)
                   if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) {
                       currentDate = previousDay
                   } else {
                       break
                   }
               } else {
                   break
               }
           }

           currentStreak = currentCount
           longestStreak = max(longestStreak, currentStreak)

           let sortedDates = completedDays.sorted(by: >)
           var longest = 0
           var tempStreak = 0
           var streakDate = today

           for dateStr in sortedDates {
               guard let date = dateFromString(dateStr) else { continue }
               if Calendar.current.isDate(date, inSameDayAs: streakDate) {
                   tempStreak += 1
                   longest = max(longest, tempStreak)
                   if let previous = calendar.date(byAdding: .day, value: -1, to: streakDate) {
                       streakDate = previous
                   }
               } else {
                   tempStreak = 0
                   streakDate = date
               }
           }

           longestStreak = longest
           UserDefaults.standard.set(longestStreak, forKey: "LongestStreak")
       }
    
    private func calculateCompletionRate() {
        // calculate completion for the current month
        let calendar = Calendar.current
        let currentMonthDates = daysInMonth.filter {
            calendar.component(.month, from: $0) == selectedMonth &&
            calendar.component(.year, from: $0) == selectedYear &&
            $0 <= Date() //only includes dates up to today
        }
        
        let totalDays = currentMonthDates.count
        if totalDays == 0 {
            completionRate = 0.0
            return
        }
        
        let completedCount = currentMonthDates.filter{ isDateCompleted($0) }.count
        completionRate = Double(completedCount) / Double(totalDays)
    }
    
    private func calculateMonthlyPoints(){
        // Initialize total points
        var points = 0
        
        // Get dates in the current month only
        let calendar = Calendar.current
        let currentMonthDates = daysInMonth.filter {
            calendar.component(.month, from: $0) == selectedMonth &&
            calendar.component(.year, from: $0) == selectedYear
        }
        
        // Calculate points for each completed habit on each day
        for date in currentMonthDates {
            let dateStr = dateString(from: date)
            if let habitsCompleted = habitViewModel.habitCompletions[dateStr], !habitsCompleted.isEmpty {
                for habitId in habitsCompleted {
                    if let habit = habitViewModel.habits.first(where: { $0.id == habitId }) {
                        // Add points based on difficulty
                        switch habit.difficulty {
                        case "Easy":
                            points += 50
                        case "Medium":
                            points += 100
                        case "Hard":
                            points += 150
                        default:
                            break
                        }
                    }
                }
            }
        }
        
        monthlyPoints = points
    }
    
    private func getDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name
        return formatter.string(from: date)
    }
    private func autoUpdateCompletedDays() {
        let calendar = Calendar.current
        let validDates = daysInMonth.filter {
            calendar.component(.month, from: $0) == selectedMonth &&
            calendar.component(.year, from: $0) == selectedYear &&
            $0 <= Date()
        }

        let updated = validDates.compactMap { date -> String? in
            let status = completionStatusForDate(date)
            return status >= 0.99 ? dateString(from: date) : nil
        }

        completedDays = Set(updated)
        saveCompletedDays()
    }
    private func dateFromString(_ str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: str)
    }



}
