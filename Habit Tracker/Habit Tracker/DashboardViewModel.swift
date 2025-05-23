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
        @State private var showDeleteAlert = false
        @State private var habitToDelete: Habit?
    
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
            VStack {
                List {
                    VStack(spacing: 20) {
                        
                        Text("Welcome to QuokkaQuest!")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .foregroundColor(Theme.textPrimary)
                        
                        calendarHeader
                        
                        Image(quokkaImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .offset(x: 7)
                            .shadow(radius: 4)
                        
                        
                        if !viewModel.habits.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                // Total points
                                Text("Daily Quokkies: \(earnedPoints) ★")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)
                                HStack {
                                    // Progress bar
                                    SwiftUI.ProgressView(value: progress)
                                        .accentColor(Theme.textPrimary)
                                        .frame(height: 8)
                                    
                                    Text("\(earnedPoints)/\(totalPoints)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        if viewModel.habits.isEmpty {
                            Text("No habits yet. Add some to track progress.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    ForEach(todaysHabits()) { habit in
                        habitCard(for: habit)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .background(Theme.background)
                
                QuoteView()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
                .alert("Are you sure you want to delete this habit?", isPresented: $showDeleteAlert, presenting: habitToDelete) { habit in
                    Button("Delete", role: .destructive) {
                        viewModel.deleteHabit(habit)
                        viewModel.saveHabits()
                        completedHabitsToday.removeAll { $0 == habit.id }
                        earnedPoints = calculateEarnedPoints()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: { _ in
                    Text("This action cannot be undone.")
                }
 
        }
        .onAppear {
            loadData()
        }
        
    }
    private var calendarHeader: some View {
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
                        .foregroundColor(isToday ? .white : Theme.textPrimary)
                        .frame(width: 28, height: 28)
                        .background(isToday ? Theme.textPrimary : Color.clear)
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
                .stroke(Theme.textPrimary, lineWidth: 2)
        )
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    @ViewBuilder
        private func habitCard(for habit: Habit) -> some View {
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
                        Text(day.prefix(1).isEmpty ? "?" : String(day.prefix(1)))
                            .frame(width: 28, height: 28)
                            .background(Theme.accent)
                            .clipShape(Circle())
                            .foregroundColor(Theme.textPrimary)
                            .font(.caption)
                    }
                }
                
                Text("Points: \(points(for: habit.difficulty))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button(action: {
                    let today = Date()
                    if viewModel.isHabitCompletedOnDate(habit, date: today) {
                        viewModel.toggleHabitCompletion(habit, date: today)
                        completedHabitsToday.removeAll { $0 == habit.id }
                    } else {
                        viewModel.toggleHabitCompletion(habit, date: today)
                        completedHabitsToday.append(habit.id)
                    }
                    earnedPoints = calculateEarnedPoints()
                    saveData()
 
                }) {
                    HStack {
                        Image(systemName: completedHabitsToday.contains(habit.id) ? "checkmark.square" : "square")
                            .foregroundColor(Theme.textPrimary)
                        Text("Mark as completed today")
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                .padding(.top, 4)
                
                if habit.timesPerDay > 1 {
                    Stepper {
                        let completed = habitCompletions[habit.id, default: 0]
                        Text("Completed: \(completed)/\(habit.timesPerDay)")
                            .font(.subheadline)
                            .foregroundColor(Theme.textPrimary)
                    }
                    onIncrement: {
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
        .contentShape(Rectangle())
        .background(
            Color(Theme.background)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                habitToDelete = habit
                showDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
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
        let habitsToday = todaysHabits()
        let total = Double(habitsToday.count)
        guard total > 0 else { return 0 }
 
        let completed = Double(
            habitsToday.filter { completedHabitsToday.contains($0.id) }.count
        )
 
        return completed / total
    }
 
 
 
       
    
    var totalPoints: Int {
        todaysHabits().reduce(0) { $0 + points(for: $1.difficulty) }
    }
    // Calculate the earned points dynamically
        func calculateEarnedPoints() -> Int {
            return todaysHabits()
                .filter { completedHabitsToday.contains($0.id) }
                .reduce(0) { $0 + points(for: $1.difficulty) }
        }
 
    func updateCompletion(for habit: Habit) {
        let completedCount = habitCompletions[habit.id, default: 0]
        let today = Date()
        let isAlreadyMarked = viewModel.isHabitCompletedOnDate(habit, date: today)
 
        if completedCount >= habit.timesPerDay {
            if !completedHabitsToday.contains(habit.id) {
                completedHabitsToday.append(habit.id)
            }
            if !isAlreadyMarked {
                viewModel.toggleHabitCompletion(habit, date: today)
            }
        } else {
            completedHabitsToday.removeAll { $0 == habit.id }
            if isAlreadyMarked {
                viewModel.toggleHabitCompletion(habit, date: today)
            }
        }
        earnedPoints = calculateEarnedPoints()
        saveData()
    }
    
    var quokkaImageName: String {
        if earnedPoints == 0 {
            return "sadquokka"
        } else if earnedPoints < totalPoints {
            return "normalquokka"
        } else {
            return "Happyquokka"
        }
    }
 
    func getDayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
 
    func todaysHabits() -> [Habit] {
        let today = Date()
        let todayName = getDayName(from: today)
        return viewModel.habits.filter {
            $0.startDate <= today && $0.frequency.contains(todayName)
        }
    }
 
 
}
 
