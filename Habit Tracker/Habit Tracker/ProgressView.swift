//ProgressView.swift
//
//  Created by Paridhi Agarwal on 4/5/2025.
//  Updated with habit tracking functionality
//
import SwiftUI

struct ProgressView: View {
    @StateObject var viewModel: ProgressViewModel
    @State private var selectedDate: Date?
    @State private var showHabitList = false
    
    init(habitViewModel: HabitViewModel) {
        _viewModel = StateObject(wrappedValue: ProgressViewModel(habitViewModel: habitViewModel))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar header with month navigation
                    calendarHeader
                    
                    // Day of week headers
                    weekdayHeaders
                    
                    // Calendar days grid
                    calendarGrid
                    
                    // Stats section
                    statsSection
                    
                    // Insights card
                    insightsCard
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
            .background(Theme.background)
            .onAppear {
                viewModel.generateDaysForSelectedMonth()
            }
            .sheet(isPresented: $showHabitList, onDismiss: {
                viewModel.generateDaysForSelectedMonth()
                viewModel.calculateStats()
            }) {
                if let date = selectedDate {
                    DayHabitsView(
                        date: date,
                        habits: viewModel.habitsForDate(date),
                        viewModel: viewModel
                    )
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var calendarHeader: some View {
        HStack {
            Button(action: { viewModel.previousMonth() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Theme.textPrimary)
            }
            
            Spacer()
            
            Text(viewModel.monthYearString())
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            Button(action: { viewModel.nextMonth() }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .padding(.horizontal)
    }
    
    private var weekdayHeaders: some View {
        let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
        
        return HStack(spacing: 0) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Theme.textPrimary.opacity(0.8))
            }
        }
        .padding(.horizontal)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(viewModel.daysInMonth, id: \.self) { date in
                CalendarDayView(
                    date: date,
                    isToday: viewModel.isDateToday(date),
                    completionStatus: viewModel.completionStatusForDate(date),
                    habitsCount: viewModel.habitsForDate(date).count,
                    onTap: {
                        selectedDate = date
                        showHabitList = true
                    }
                )
                .id(viewModel.dateString(from: date))
            }
        }
        .padding(.horizontal)
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Your Stats")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stats cards
            HStack(spacing: 12) {
                StatCard(title: "Current Streak", value: "\(viewModel.currentStreak) days")
                StatCard(title: "Longest Streak", value: "\(viewModel.longestStreak) days")
            }
            
            HStack(spacing: 12) {
                StatCard(title: "Completion Rate", value: "\(Int(viewModel.completionRate * 100))%")
                StatCard(title: "Monthly Points", value: "\(viewModel.monthlyPoints)")
            }
        }
        .padding(.horizontal)
    }
    
    private var insightsCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Habit Completion Insights")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                
                if viewModel.currentStreak > 0 {
                    Text("Great job! You're on a \(viewModel.currentStreak)-day streak. Keep up the good work!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Tap on any day to view and mark your habits as completed.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isToday: Bool
    let completionStatus: Double // 0 = none, 0.5 = partial, 1 = complete
    let habitsCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16))
                    .fontWeight(isToday ? .bold : .regular)
                
                // Show indicators only if there are habits for this day
                if habitsCount > 0 {
                    // Small dot indicator for habits
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(colorForCompletionStatus())
                        .opacity(habitsCount > 0 ? 1.0 : 0.0)
                }
            }
            .padding(.vertical, 4)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(backgroundForState())
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday ? Theme.primary : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private func backgroundForState() -> Color {
        if completionStatus >= 0.99 {
            return Theme.accent // Fully completed
        } else if completionStatus > 0 {
            return Theme.accent.opacity(0.5) // Partially completed
        } else {
            return Theme.muted // Not completed
        }
    }
    
    private func colorForCompletionStatus() -> Color {
        if completionStatus >= 0.99 {
            return Color.green
        } else if completionStatus > 0 {
            return Color.orange
        } else {
            return Color.gray
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        CardView {
            VStack(spacing: 8) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// New view to display and manage habits for a specific day
struct DayHabitsView: View {
    let date: Date
    let habits: [Habit]
    let viewModel: ProgressViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "No Habits for This Day",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("You don't have any habits scheduled for this day.")
                    )
                } else {
                    List {
                        ForEach(habits) { habit in
                            HabitRowView(habit: habit, date: date, viewModel: viewModel)
                        }
                    }
                }
            }
            .navigationTitle(formatDate(date))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct HabitRowView: View {
    let habit: Habit
    let date: Date
    let viewModel: ProgressViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                
                    .foregroundColor(Theme.textPrimary)

                Text("Difficulty: \(habit.difficulty)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(viewModel.isHabitCompletedOnDate(habit, date: date) ? "Completed" : "Pending")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(viewModel.isHabitCompletedOnDate(habit, date: date) ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                .foregroundColor(viewModel.isHabitCompletedOnDate(habit, date: date) ? Color.green : Color.gray)
                .clipShape(Capsule())
        }
        .padding(.vertical, 6)
    }
}
