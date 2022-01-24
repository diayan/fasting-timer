//
//  ProgressRingView.swift
//  FastingTimer
//
//  Created by diayan siat on 21/01/2022.
//

import SwiftUI

/**
 The progress ring will have two rings i.e a  placeholder progress  ring and then the colored progress ring
 */
struct ProgressRingView: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            //MARK: Placeholder ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            //MARK: Colored Ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
            
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4652583599, green: 0.1806794107, blue: 0.7839112878, alpha: 1)), Color(#colorLiteral(red: 0.8221800327, green: 0.1186390743, blue: 0.352390945, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.7679252625, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.9273050427, green: 0.8746910691, blue: 0, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.6037489772, blue: 0, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect((Angle(degrees: 270)))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            
            //MARK: Outer VStack contains elapsed time and remaining time
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    VStack(spacing: 5) {
                        Text("Upcoming fast")
                            .opacity(0.7)
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }else {
                    VStack(spacing: 5) {
                        Text("Elapsed time")
                            .opacity(0.7)
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    VStack(spacing: 5) {
                        if !fastingManager.elapsed {
                            Text("Remaining time")
                                .opacity(0.7)
                        }else {
                            Text("Extra time")
                                .opacity(0.7)
                        }
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onReceive(timer, perform: {_ in
            fastingManager.track()
        })
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView()
            .environmentObject(FastingManager())
    }
}
