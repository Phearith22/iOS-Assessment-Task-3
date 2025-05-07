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
