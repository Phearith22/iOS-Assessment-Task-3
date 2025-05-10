//
//  ProgressView.swift
//
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct ProgressView: View {
    @StateObject var viewModel: ProgressViewModel
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    
    init(habitViewModel: HabitViewModel) {
        _viewModel = StateObject(wrappedValue: ProgressViewModel(habitViewModel: habitViewModel))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar header with month navigation
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
                    
                    // Day of week headers
                    HStack(spacing: 0) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Theme.textPrimary.opacity(0.8))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calendar days grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(viewModel.daysInMonth, id: \.self) { date in
                            CalendarDayView(
                                date: date,
                                isToday: viewModel.isDateToday(date),
                                isCompleted: viewModel.isDateCompleted(date),
                                onTap: {
                                    viewModel.toggleCompletionForDate(date)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Stats section
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
                    
                    // Top Habits section
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Habit Completion Insights")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Keep tracking your habits consistently to see your completion patterns and insights.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
            .background(Theme.background)
            .onAppear {
                viewModel.generateDaysForSelectedMonth()
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isToday: Bool
    let isCompleted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16))
                    .fontWeight(isToday ? .bold : .regular)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                backgroundForState()
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday ? Theme.primary : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private func backgroundForState() -> Color {
        if isCompleted {
            return Theme.accent
        } else {
            return Theme.muted
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

