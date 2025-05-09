

//  ProgressViewModel.swift
//  Habit Tracker
//
//  Created by Wong Wilson on 9/5/2025.
//
import Foundation
import SwiftUI
import Combine

class YourProgressViewModel : ObservableObject{
    @Published var selectedMonth: Int
    @Published var selectedYear: Int
    @Published var currentDate = Date()
    @Published var daysInMonth: [Date] = []
    @Published var completedDays: Set<String> = []
    //stats
    @Published var currentStreak: Int = 5
    @Published var longestStreak: Int = 10
    @Published var completionRate: Double = 0.7
    @Published var monthlyPoints: Int = 2400
    
    private var HabitViewModel : HabitViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(habitViewModel: HabitViewModel){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: Date())
        
        self.selectedMonth = components.month ?? 1
        self.selectedYear = components.year ?? 2025
        self.HabitViewModel = habitViewModel
        // Initial setup
        // self.generateDaysForSelectedMonth()
        //self.loadCompletedDays()
        habitViewModel.$habits
            .sink { [weak self] habits in
                self?.loadCompletedDays()
                self?.calculateStats()
            }
        
            .store(in: &cancellables)
    }
    
    func generateDaysForSelectedMonth() {
        daysInMonth.removeAll()
        
        var dateComponents = DateComponents()
        dateComponents.month = selectedMonth
        dateComponents.year = selectedYear
        dateComponents.day = 1
        
        let calendar = Calendar.current
        
        //get the first day of the month
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else { return }
        
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
    
        
    
    
    
}

