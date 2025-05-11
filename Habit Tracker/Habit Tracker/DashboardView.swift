//
//  DashboardView.swift
//  
//
//  Created by Pichsophearith lay on 9/5/2025.
//
import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var showAddHabit = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            VStack(spacing: 0) {
                DashboardViewModel(viewModel: viewModel)
                
                Spacer()
                
                QuoteView()
                    .font(.footnote)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
            }
            
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .tag(0)
            
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
            
            ProgressView()
                            .tabItem {
                                Label("Progress", systemImage: "calendar")
                            }
                            .tag(1)

                   
            

                    ProfileView(viewModel: viewModel)
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

