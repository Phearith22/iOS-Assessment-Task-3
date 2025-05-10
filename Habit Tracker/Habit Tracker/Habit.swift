//
//  Habit.swift
//  
//
//  Created by Paridhi Agarwal on 4/5/2025.
//
import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var frequency: [String]
    var difficulty: String
    var startDate: Date
    var timesPerDay: Int
}

