//
//  AddHabitView.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("Add a new habit")
                    .font(.title2).bold()
                    Spacer()
                    Button(action: {
                    dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .padding()
    }
}
