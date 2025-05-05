//
//  AddHabitView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @State private var habitName: String = ""
    @State private var difficulty: String = "Medium"
    let difficultyOptions = ["Easy", "Medium", "Hard"]


    var body: some View {
        VStack(alignment: .leading, spacing: 20)  {
            HStack {
                Text("Add a new habit")
                    .font(.title2).bold()
                    .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                    dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 24) {
                // Habit Name
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(.headline)
                                .foregroundColor(.black)
                            TextField("e.g. Drink Water", text: $habitName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    // Frequency
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }

                    // Difficulty
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty")
                                .font(.headline)
                            HStack(spacing: 12) {
                                ForEach(difficultyOptions, id: \.self) { option in
                                    Button(action: {
                                        difficulty = option
                                    }) {
                                        VStack {
                                            Text(option)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                                .frame(maxWidth: .infinity)
                                            
                                            Text(points(for: option))
                                                .font(.caption)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding()
                                        .frame(width: 90)
                                        .background(difficulty == option ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
                                        .cornerRadius(12)
                                        .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }


                    // Notification
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notify me")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }

                    // Start Date
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Date")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct CardView<Content: View>: View {
    let content: () -> Content

    var body: some View {
        content()
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

private func points(for difficulty: String) -> String {
    switch difficulty {
    case "Easy": return "50 points"
    case "Medium": return "100 pts"
    case "Hard": return "150 pts"
    default: return ""
    }
}
