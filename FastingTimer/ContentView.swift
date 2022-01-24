//
//  ContentView.swift
//  FastingTimer
//
//  Created by diayan siat on 21/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var fastingManager = FastingManager()
    var title: String {
        switch fastingManager.fastingState {
        case .notStarted:
            return "Get Started"
        case .fasting:
            return "You are fasting"
        case .feeding:
            return "You are eating"
        }
    }
    
    var body: some View {
        ZStack{
            //MARK: Background
            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                .ignoresSafeArea()
            
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 40) {
                //MARK: Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                //MARK: Fasting plan
                Text(fastingManager.fastingPlan.rawValue)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
                Spacer()
            }.padding()
            
            VStack(spacing: 40) {
                //MARK: Progress Ring
                ProgressRingView()
                    .environmentObject(fastingManager)
                
                //MARK
                HStack(spacing: 60) {
                    
                    //MARK: Start time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                    
                    
                    //MARK: Start time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)
                        
                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                }
                
                //MARK: Start fasting button
                Button(action: {
                    fastingManager.toggleFastingState()
                }, label: {
                    Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                })
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
