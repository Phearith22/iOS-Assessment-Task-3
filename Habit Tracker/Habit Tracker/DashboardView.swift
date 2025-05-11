//
//  DashboardView.swift
//  
//
//  Created by Pichsophearith lay on 9/5/2025.
//
import SwiftUI

struct AddHabitTrigger: Identifiable {
    let id = UUID()
}

struct DashboardView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var showAddHabitSheetTrigger: AddHabitTrigger?
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            
            DashboardViewModel(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .tag(0)
            
            
            Color.clear
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add")
                }
                .tag(3)
            ProgressView(habitViewModel: viewModel)
                .tabItem {
                    Label("Progress", systemImage: "calendar")
                }
                .tag(1)
            
            ProfileView(viewModel: viewModel, progressViewModel: ProgressViewModel(habitViewModel: viewModel))
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) {
            if selectedTab == 3 {
                selectedTab = 0
                showAddHabitSheetTrigger = AddHabitTrigger()
            }
        }
        .sheet(item: $showAddHabitSheetTrigger) { _ in
            AddHabitView(viewModel: viewModel, selectedTab: $selectedTab)
        }
    
    }
}

