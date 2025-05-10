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
            
            
            DashboardViewModel(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .tag(0)
            
            ProgressView(habitViewModel: HabitViewModel())
                            .tabItem {
                                Label("Progress", systemImage: "calendar")
                            }
                            .tag(1)

                   
            
            Color.clear
                           .tabItem {
                               Image(systemName: "plus.circle")
                               Text("Add")
                           }
                           .onAppear {
                              
                               showAddHabit = true
                               selectedTab = 0
                           }
                           .tag(3)

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

