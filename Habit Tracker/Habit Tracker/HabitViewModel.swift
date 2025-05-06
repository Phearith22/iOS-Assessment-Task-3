//
//  HabitViewModel.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import Foundation

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []

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

    init() {
        loadHabits()
    }
}
