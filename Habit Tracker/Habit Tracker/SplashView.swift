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
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                // Quokka Image with Ellipse
                ZStack {
                    Ellipse()
                        .fill(Theme.accent)
                        .frame(width: 220, height: 50)
                        .offset(y: 120)

                    Image("Happy_quokka")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 360)
                }
                
                // Title
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

                //OR
                Text ("OR")
                    .font(.footnote)
                    .foregroundColor(Theme.textSecondary)

                // Email Signup Button
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
                        RoundedRectangle(cornerRadius:15)
                        .stroke(Theme.muted, lineWidth:1)
                    )
                    .foregroundColor(Theme.textSecondary)
                }
                
                // Footer Log In
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
            //Navigation destination
                .navigationDestination (isPresented: &isLoggedIn) {
                    DashboardView()
                }
            }
            .ignoresSafeArea()
        }
    }

