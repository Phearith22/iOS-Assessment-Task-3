//
//  DashboardView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var showAddHabit = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
                    VStack {
                        Text("Dashboard")
                        Button("Add Habit") {
                            showAddHabit = true
                        }
                    }
                    .tabItem {
                        Label("Dashboard", systemImage: "house")
                    }
                    .tag(0)

                    ProgressView(viewModel: viewModel)
                        .tabItem {
                            Label("Progress", systemImage: "chart.bar")
                        }
                        .tag(1)

                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(2)
                }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView(viewModel: viewModel)
            
        }
           
    }
}

