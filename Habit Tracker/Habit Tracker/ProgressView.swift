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
                     
                    }
                    .padding()
                }
                .navigationTitle("Your Progress")
            }
            .background(Theme.background)
        }
 }
