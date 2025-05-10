//
//  SplashView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct SplashView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            DashboardView(viewModel: HabitViewModel())
        } else {
            VStack(spacing: 20) {
                Spacer()

                ZStack {
                    Ellipse()
                        .fill(Theme.accent)
                        .frame(width: 220, height: 50)
                        .offset(y: 120)

                    Image("Happy quokka")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 360)
                }

                Text("QuokkaQuest")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Button {
                    isLoggedIn = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                        Text("Continue with Google")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: 230)
                    .padding()
                    .background(Theme.accent)
                    .cornerRadius(12)
                    .foregroundColor(Theme.textPrimary)
                }

                Text("OR")
                    .font(.footnote)
                    .foregroundColor(Theme.textSecondary)

                Button {
                    isLoggedIn = true
                } label: {
                    Text("Sign up with Email")
                        .fontWeight(.medium)
                        .frame(maxWidth: 230)
                        .padding()
                        .background(Theme.card)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Theme.muted, lineWidth: 1)
                        )
                        .foregroundColor(Theme.textSecondary)
                }

                VStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(Theme.textSecondary)
                    Button("Log in") {
                        isLoggedIn = true
                    }
                    .font(.footnote)
                    .foregroundColor(Theme.primary)
                }

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 30)
            .background(Theme.background)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $isLoggedIn) {
                DashboardView(viewModel: HabitViewModel())
            }
        }
    }
}
