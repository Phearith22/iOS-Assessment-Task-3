//
//  ProgressView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct ProgressView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var completedHabitsToday: [UUID] = []

        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        if !viewModel.habits.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                // Progress bar
                                SwiftUI.ProgressView(value: progress)
                                    .accentColor(.green)
                                    .frame(height: 8)

                                // Total points
                                Text("Total Points Earned Today: \(earnedPoints)")
                                    .font(.headline)
                            }
                            .padding(.horizontal)
                        }
                        
                        ForEach(viewModel.habits.filter { !completedHabitsToday.contains($0.id) }) { habit in
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

                                    Toggle(isOn: Binding<Bool>(
                                        get: { completedHabitsToday.contains(habit.id) },
                                        set: { newValue in
                                            if newValue {
                                                completedHabitsToday.append(habit.id)
                                            } else {
                                                completedHabitsToday.removeAll { $0 == habit.id }
                                            }
                                        }
                                    )) {
                                        Text("Mark as completed today")
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .green))
                                }
                            }
                        }
                        
                        if viewModel.habits.isEmpty {
                            Text("No habits yet. Add some to track progress.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                     
                    }
                    .padding()
                }
                .navigationTitle("Your Progress")
            }
            .background(Theme.background)
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

    var earnedPoints: Int {
        viewModel.habits
            .filter { completedHabitsToday.contains($0.id) }
            .reduce(0) { $0 + points(for: $1.difficulty) }
    }
    
 }
