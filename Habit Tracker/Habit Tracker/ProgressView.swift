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
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Progress")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .padding(.top)
                .padding(.horizontal)
        }
    }
}
