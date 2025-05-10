//
//  DashboardViewModel.swift
//  Habit Tracker
//
//  Created by Pichsophearith lay on 9/5/2025.
//

import SwiftUI

struct DashboardViewModel: View {
        @ObservedObject var viewModel: HabitViewModel
        @State private var completedHabitsToday: [UUID] = []
        @State private var earnedPoints: Int = 0
        @State private var habitCompletions: [UUID: Int] = [:]
    
    // Save the completed habits and earned points to UserDefaults
        private func saveData() {
            let completedHabitsData = completedHabitsToday.map { $0.uuidString }
            UserDefaults.standard.set(completedHabitsData, forKey: "completedHabitsToday")
            UserDefaults.standard.set(earnedPoints, forKey: "earnedPoints")
        }

        // Load the saved habits and points from UserDefaults
        private func loadData() {
            if let savedCompletedHabits = UserDefaults.standard.array(forKey: "completedHabitsToday") as? [String] {
                completedHabitsToday = savedCompletedHabits.compactMap { UUID(uuidString: $0) }
            }
            earnedPoints = UserDefaults.standard.integer(forKey: "earnedPoints")
        }


    var body: some View {
            ZStack {
                Theme.background
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Text("Welcome to QuokkaQuest!")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        HStack(spacing: 10) {
                            ForEach(0..<7) { index in
                                let date = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!
                                let weekdaySymbol = weekdaySymbols[index]
                                let dayNumber = Calendar.current.component(.day, from: date)
                                let isToday = Calendar.current.isDateInToday(date)

                                VStack {
                                    Text(weekdaySymbol)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(dayNumber)")
                                        .fontWeight(isToday ? .bold : .regular)
                                        .foregroundColor(isToday ? .white : .black)
                                        .frame(width: 28, height: 28)
                                        .background(isToday ? Color.black : Color.clear)
                                        .clipShape(Circle())
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(Theme.card)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 2)
                        )
                                                   
                        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "trophy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding()
                        
                        if !viewModel.habits.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                // Total points
                                Text("Daily Quokkies: \(earnedPoints) ★")
                                    .font(.headline)
                                HStack {
                                // Progress bar
                                SwiftUI.ProgressView(value: progress)
                                    .accentColor(.black)
                                    .frame(height: 8)
                                
                                Text("\(earnedPoints)/\(totalPoints)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                
                               
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        ForEach(viewModel.habits) { habit in
                            CardView {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(habit.name)
                                            .font(.headline)
                                            .foregroundColor(Theme.textPrimary)
                                        Spacer()
                                        Text(habit.difficulty)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    HStack(spacing: 5) {
                                        ForEach(habit.frequency, id: \.self) { day in
                                            Text(day.prefix(1))
                                                .frame(width: 28, height: 28)
                                                .background(Theme.accent)
                                                .clipShape(Circle())
                                                .foregroundColor(.black)
                                                .font(.caption)
                                        }
                                    }
                                    Text("Points: \(points(for: habit.difficulty))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    
                                    Button(action: {
                                        if completedHabitsToday.contains(habit.id) {
                                            completedHabitsToday.removeAll { $0 == habit.id }
                                        } else {
                                            completedHabitsToday.append(habit.id)
                                        }
                                        earnedPoints = calculateEarnedPoints()
                                        saveData()
                                    }) {
                                        HStack {
                                            Image(systemName: completedHabitsToday.contains(habit.id) ? "checkmark.square" : "square")
                                                .foregroundColor(.black)
                                            Text("Mark as completed today")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .padding(.top, 4)

                                    if habit.timesPerDay > 1 {
                                        Stepper {
                                            let completed = habitCompletions[habit.id, default: 0]
                                            Text("Completed: \(completed)/\(habit.timesPerDay)")
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                        } onIncrement: {
                                            var current = habitCompletions[habit.id, default: 0]
                                            if current < habit.timesPerDay {
                                                current += 1
                                                habitCompletions[habit.id] = current
                                                updateCompletion(for: habit)
                                            }
                                        } onDecrement: {
                                            var current = habitCompletions[habit.id, default: 0]
                                            if current > 0 {
                                                current -= 1
                                                habitCompletions[habit.id] = current
                                                updateCompletion(for: habit)
                                            }
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                            }
                            .opacity(completedHabitsToday.contains(habit.id) ? 0.4 : 1.0)
                        }
                        
                        if viewModel.habits.isEmpty {
                            Text("No habits yet. Add some to track progress.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                    }
                    .padding()
                }
                .navigationTitle("Welcome to Quokka!")
        }
        .onAppear {
            loadData()
        }
        
    }
    
    private var startOfWeek: Date {
            Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        }

        private var weekdaySymbols: [String] {
            let symbols = Calendar.current.shortWeekdaySymbols
            let firstWeekday = Calendar.current.firstWeekday - 1
            return Array(symbols[firstWeekday...] + symbols[..<firstWeekday])
        }
        
        func points(for difficulty: String) -> Int {
            switch difficulty {
            case "Easy": return 50
            case "Medium": return 100
            case "Hard": return 150
            default: return 0
            }
        }

        var progress: Double {
            let total = Double(viewModel.habits.count)
            guard total > 0 else { return 0 }
            return Double(completedHabitsToday.count) / total
        }

       
    
    var totalPoints: Int {
        viewModel.habits.reduce(0) { $0 + points(for: $1.difficulty) }
    }
    // Calculate the earned points dynamically
        func calculateEarnedPoints() -> Int {
            return viewModel.habits
                .filter { completedHabitsToday.contains($0.id) }
                .reduce(0) { $0 + points(for: $1.difficulty) }
        }

    func updateCompletion(for habit: Habit) {
        if habitCompletions[habit.id, default: 0] >= habit.timesPerDay {
            if !completedHabitsToday.contains(habit.id) {
                completedHabitsToday.append(habit.id)
            }
        } else {
            completedHabitsToday.removeAll { $0 == habit.id }
        }
        earnedPoints = calculateEarnedPoints()
        saveData()
    }

}


