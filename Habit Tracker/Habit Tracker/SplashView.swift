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
                        .fill(Color(red: 0.88, green: 0.97, blue: 1.0))
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
                    .foregroundColor(Color(red:0.168, green: 0.227, blue: 0.404))

                Button {
                    isLoggedIn = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                        Text("Continue with Google")
                        .fontWeight(.medium)
                        .foregroundColor(Color(red:0.168, green:0.227, blue:0.404))
                    }
                    .frame(maxWidth: 230)
                    .padding()
                    .background(Color(red:0.878, green:0.949, blue:0.91))
                    .cornerRadius(12)
                }

                //OR
                Text ("OR")
                    .font(.footnote)
                    .foregroundColor(.black)

                // Email Signup Button
                Button {
                    isLoggedIn = true
                } label: {
                    Text("Sign up with Email")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .frame(maxWidth: 230)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius:15)
                        .stroke(Color.gray.opacity(0.3), lineWidth:1)
                    )
                }
                
                // Footer Log In
                VStack(spacing: 4) {
                    Text("Already have an account?")
                    .font(.footnote)
                    foregroundColor(.black)
                    Button("Log in") {
                        isLoggedIn = true
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }

                Spacer()

                //Navigation destination
                .navigationDestination (isPresented: &isLoggedIn) {
                    DashboardView()
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 30)
            .background(Color(red: 0.976, green:0.961, blue:0.906))
            .ignoresSafeArea()
        }
    }
}

