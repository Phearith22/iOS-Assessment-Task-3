//
//  ProfileView.swift
//  Habit Tracker
//
//  Created by Paridhi Agarwal on 4/5/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: HabitViewModel
    var currentStreak = 5
    var daysActive = 45

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    Text("Profile")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Profile Summary Card
                    VStack(spacing: 16) {
                        HStack(alignment: .top, spacing: 16) {
                            Image("Happyquokka")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Samantha C")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)

                                Text("samantha.c@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .underline()

                                Button("Edit Profile") {}
                                    .disabled(true)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.purple.opacity(0.15))
                                    .foregroundColor(.purple)
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                        Divider()
                        ProfileStatRow(label: "Current Habits", value: "\(viewModel.habits.count)")
                        Divider()
                        ProfileStatRow(label: "Current Streak", value: "\(currentStreak)")
                        Divider()
                        ProfileStatRow(label: "Days Active", value: "\(daysActive)")
                    }
                    .padding(16)
                    .background(Theme.card)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

                    // Account Options
                    VStack(spacing: 0) {
                        HStack {
                            Text("Account")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                        }
                        .padding()
                        Divider()

                        AccountRow(label: "Change Password")
                        Divider()
                        AccountRow(label: "Sign Out")
                        Divider()
                        AccountRow(label: "Contact support / feedback")
                    }
                    .background(Theme.card)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(
                Theme.background
                    .ignoresSafeArea()
            )
        }
    }
}

fileprivate struct ProfileStatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(Theme.textPrimary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

fileprivate struct AccountRow: View {
    let label: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

