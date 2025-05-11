//
//  HabitViewModel.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import Foundation

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var habitCompletions: [String: Set<UUID>] = [:]

    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }

    func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: "Habits")
        }
    }

    func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: "Habits"),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
    func deleteHabit(_ habit: Habit) {
            habits.removeAll { $0.id == habit.id }
        }

    func isHabitCompletedOnDate(_ habit: Habit, date: Date) -> Bool {
        let key = dateKey(date)
        return habitCompletions[key]?.contains(habit.id) ?? false
    }

    func toggleHabitCompletion(_ habit: Habit, date: Date) {
        let key = dateKey(date)
        if habitCompletions[key]?.contains(habit.id) == true {
            habitCompletions[key]?.remove(habit.id)
        } else {
            if habitCompletions[key] == nil {
                habitCompletions[key] = []
            }
            habitCompletions[key]?.insert(habit.id)
        }
        saveHabitCompletions()
    }

    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func saveHabitCompletions() {
        if let encoded = try? JSONEncoder().encode(habitCompletions) {
            UserDefaults.standard.set(encoded, forKey: "HabitCompletions")
        }
    }
    
    private func loadHabitCompletions() {
        if let data = UserDefaults.standard.data(forKey: "HabitCompletions"),
           let decoded = try? JSONDecoder().decode([String: Set<UUID>].self, from: data) {
            habitCompletions = decoded
        }
    }
    
    init() {
        loadHabits()
        loadHabitCompletions()
    }
}
