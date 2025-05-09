//
//  ProgressView.swift
//  Habit Tracker
//
//  Created by Pichsophearith lay on 9/5/2025.
//

import SwiftUI

struct ProgressView: View {

    @State private var color: Color = .blue
    @State private var date = Date.now
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    var body: some View {
        NavigationView{
            ZStack{
                Color(.white.withAlphaComponent(0.2))
                    .ignoresSafeArea()
                VStack {
                    
                    
                    Text("Your Progress")
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView{
                        VStack(spacing: 16){
                            //calander component
                            
                            //statsSection
                            
                            Spacer()
                        }
                    }
                    //tabbat
                }
            }
        }
}
