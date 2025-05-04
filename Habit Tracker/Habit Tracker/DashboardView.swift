//
//  DashboardView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct DashboardView: View {
    @State private var showAddHabit = false

    var body: some View {
        VStack {
            Text("Dashboard goes here")

            Button("Add Habit") {
                showAddHabit = true
            }
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView()
        }
    }
}
