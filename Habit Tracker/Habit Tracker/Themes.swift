//
//  Themes.swift
//  Habit Tracker
//
//  Created by Paridhi Agarwal on 6/5/2025.
//
import SwiftUI

struct Theme {
    static let background = Color(red: 254/255, green: 251/255, blue: 236/255)
    static let primary = Color(red: 28/255, green: 36/255, blue: 73/255)
    static let card = Color.white
    static let accent = Color.green.opacity(0.15)
    static let muted = Color.gray.opacity(0.15)
    static let textPrimary = primary
    static let textSecondary = Color.black
}

//Resusable white background cards
struct CardView<Content: View>: View {
    let content: () -> Content

    var body: some View {
        content()
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.card)
            .cornerRadius(18)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
//Resusable Blue Button
struct BlueButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.primary)
                .cornerRadius(18)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

struct SelectableBoxButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .fontWeight(.semibold)
                .font(.system(size: 16))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(isSelected ? Theme.accent : Theme.muted)
                .cornerRadius(12)
                .foregroundColor(Theme.primary)
        }
    }
}

