//
//  AddHabitView.swift
//
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct AddHabitView: View {
    @State private var habitName: String = ""
    @State private var selectedDays: [String] = []
    @State private var difficulty: String = "Medium"
    @State private var startDate = Date()
    @State private var showTime = true
    @State private var notificationEnabled = true
    @State private var notificationTime = Date()
    @State private var timesPerDay: Int = 1
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    
    let allDays = ["M", "T", "W", "T", "F", "S", "S"]
    let weekdays = ["M0", "T1", "W2", "T3", "F4"]
    let weekends = ["S5", "S6"]
    let everyday = ["M0", "T1", "W2", "T3", "F4", "S5", "S6"]
    let difficultyOptions = ["Easy", "Medium", "Hard"]
    
    var isEverydaySelected: Bool {
        Set(selectedDays) == Set(everyday)
    }
    var isWeekdaysSelected: Bool {
        Set(selectedDays) == Set(weekdays)
    }
    var isWeekendsSelected: Bool {
        Set(selectedDays) == Set(weekends)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20)  {
            // Header
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
                    
                    //How many times per day
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How many times per day?")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(spacing: 24) {
                                Button(action: {
                                    if timesPerDay > 1 {
                                        timesPerDay -= 1
                                    }
                                }) {
                                    Text("–")
                                        .font(.title2)
                                        .frame(width: 40, height: 40)
                                        .background(Theme.accent)
                                        .cornerRadius(10)
                                        .foregroundColor(Theme.textPrimary)
                                }

                                Text("\(timesPerDay)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.textPrimary)

                                Button(action: {
                                    timesPerDay += 1
                                }) {
                                    Text("+")
                                        .font(.title2)
                                        .frame(width: 40, height: 40)
                                        .background(Theme.accent)
                                        .cornerRadius(10)
                                        .foregroundColor(Theme.textPrimary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        }
                    }
                    // Frequency
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            // Day Circles
                            HStack {
                                ForEach(allDays.indices, id: \.self) { index in
                                    let dayKey = allDays[index] + String(index)
                                    Button(action: {
                                        toggleDay(dayKey)
                                    }) {
                                        Text(allDays[index])
                                            .fontWeight(.semibold)
                                            .frame(width: 40, height: 40)
                                            .background(selectedDays.contains(dayKey) ? Theme.accent : Theme.muted)
                                            .foregroundColor(Theme.textPrimary)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            // Quick Select Buttons
                            HStack(spacing: 12) {
                                SelectableBoxButton(label: "Everyday", isSelected: isEverydaySelected) {
                                    selectedDays = isEverydaySelected ? [] : everyday
                                }
                                SelectableBoxButton(label: "Weekdays", isSelected: isWeekdaysSelected) {
                                    selectedDays = isWeekdaysSelected ? [] : weekdays
                                }
                                SelectableBoxButton(label: "Weekends", isSelected: isWeekendsSelected) {
                                    selectedDays = isWeekendsSelected ? [] : weekends
                                }
                                
                            }

                            .padding(.top, 4)
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
                                        .frame(width: 100)
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
                            Toggle("Notify me", isOn: $notificationEnabled)
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                                .toggleStyle(SwitchToggleStyle(tint: Theme.textPrimary))
                            if notificationEnabled {
                                DatePicker("Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .foregroundColor(Theme.textPrimary)
                            }
                        }
                    }

                    // Start Date
                    CardView {
                        HStack {
                            Text("Start Date")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            DatePicker(
                                "",
                                selection: $startDate,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(.compact)
                        }
                    }
                    // Save Button
                    BlueButton(
                        title: "Save",
                        isDisabled: habitName.isEmpty || selectedDays.isEmpty
                    ) {
                        let finalDays = selectedDays.map { cleanDay($0) }
                        let today = Date()
                        let todayName = getDayName(from: today) // e.g., "Sunday"

                        let habitStartDate: Date
                        if finalDays.contains(todayName) {
                            habitStartDate = today
                        } else {
                            habitStartDate = findNextValidDate(from: today, matching: finalDays)
                        }

                        let newHabit = Habit(
                            name: habitName,
                            frequency: finalDays,
                            difficulty: difficulty,
                            startDate: habitStartDate,
                            timesPerDay: timesPerDay
                        )

                        viewModel.addHabit(newHabit)
                        habitName = ""
                        selectedDays = []
                        difficulty = "Medium"
                        dismiss()
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Theme.background)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
    }

    func toggleDay(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }

    func cleanDay(_ raw: String) -> String {
        switch raw {
            case "M0": return "Monday"
            case "T1": return "Tuesday"
            case "W2": return "Wednesday"
            case "T3": return "Thursday"
            case "F4": return "Friday"
            case "S5": return "Saturday"
            case "S6": return "Sunday"
            default: return raw
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
    func getDayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    func findNextValidDate(from start: Date, matching days: [String]) -> Date {
        let calendar = Calendar.current
        for offset in 1...7 {
            if let nextDate = calendar.date(byAdding: .day, value: offset, to: start) {
                let nextDayName = getDayName(from: nextDate)
                if days.contains(nextDayName) {
                    return nextDate
                }
            }
        }
        return start
    }

}

