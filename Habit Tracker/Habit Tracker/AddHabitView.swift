//
//  AddHabitView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @State private var habitName: String = ""
    @State private var difficulty: String = "Medium"
    let difficultyOptions = ["Easy", "Medium", "Hard"]
    
    @State private var selectedDays: [String] = []
    let allDays = ["M", "T", "W", "T", "F", "S", "S"]

    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20)  {
            HStack {
                Text("Add a new habit")
                    .font(.title2).bold()
                    .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: {
                    dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 24) {
                // Habit Name
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            TextField("e.g. Drink Water", text: $habitName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    // Frequency
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            HStack {
                                ForEach(allDays.indices, id: \.self) { index in
                                    let dayKey = allDays[index] + String(index) // e.g., T0, T3
                                    Button(action: {
                                        toggleDay(dayKey)
                                    }) {
                                        Text(String(allDays[index]))
                                            .fontWeight(.medium)
                                            .frame(width: 40, height: 40)
                                            .background(selectedDays.contains(dayKey) ? Theme.accent : Theme.muted)
                                            .foregroundColor(Theme.textPrimary)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }

                    // Difficulty
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            HStack(spacing: 12) {
                                ForEach(difficultyOptions, id: \.self) { option in
                                    Button(action: {
                                        difficulty = option
                                    }) {
                                        VStack {
                                            Text(option)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                                .frame(maxWidth: .infinity)
                                            
                                            Text(points(for: option))
                                                .font(.caption)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding()
                                        .frame(width: 90)
                                        .background(difficulty == option ? Theme.accent : Theme.muted)
                                        .cornerRadius(12)
                                        .foregroundColor(Theme.textPrimary)
                                    }
                                }
                            }
                        }
                    }


                    // Notification
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notify me")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                        }
                    }

                    // Start Date
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Date")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                        }
                    }
                    
                    // Save Button
                    BlueButton(
                        title: "Save",
                        isDisabled: habitName.isEmpty || selectedDays.isEmpty
                    ) {
                        let finalDays = selectedDays.map { cleanDay($0) }
                        let newHabit = Habit(           //newHabit - habit object will be used later as a display in the dashboard, ignore warning right now
                            name: habitName,
                            frequency: finalDays,
                            difficulty: difficulty,
                            startDate: Date() // replace with startDate var when added
                        )
                        viewModel.addHabit(newHabit)
                        habitName = ""
                        selectedDays = []
                        difficulty = "Medium"
                        dismiss()
                    }
                    
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Theme.background)
        .ignoresSafeArea()
    }
    
    func toggleDay(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
    
    private func points(for difficulty: String) -> String {
        switch difficulty {
        case "Easy": return "50 points"
        case "Medium": return "100 pts"
        case "Hard": return "150 pts"
        default: return ""
        }
    }
    
    func cleanDay(_ raw: String) -> String {
        let letter = String(raw.prefix(1))
        switch letter {
            case "M": return "Monday"
            case "T": return raw.contains("0") ? "Tuesday" : "Thursday"
            case "W": return "Wednesday"
            case "F": return "Friday"
            case "S": return raw.contains("5") ? "Saturday" : "Sunday"
            default: return raw
        }
    }

}





