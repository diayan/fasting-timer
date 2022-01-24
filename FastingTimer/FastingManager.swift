//
//  FastingManager.swift
//  FastingTimer
//
//  Created by diayan siat on 21/01/2022.
//

import Foundation
import SwiftUI

enum FastingState {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"
    
    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0

    @Published private(set) var endTime: Date {
        didSet {
            print("endTime: \(endTime.formatted(.dateTime.month().day().hour().minute().second()))")
        }
    }
    
    @Published private(set) var startTime: Date {
        //update end time as soon as the start time changes
        didSet {
            print("startTime: \(startTime.formatted(.dateTime.month().day().hour().minute().second()))")
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            }else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60  //multiplied by 60 and 60 to turn it into hours
    }
    
    var feedingTime: Double {
        return (24 - fastingPlan.fastingPeriod) * 60 * 60  //multiplied by 60 and 60 to turn it into hours
    }

    init() {
        let calendar = Calendar.current
        
//        var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
//        components.hour = 20
//        print(components)
        
        
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        
        print("scheduledTime: \(scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))")
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60 )
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elapsedTime = 0.0
    }
    
    func track() {
        guard fastingState != .notStarted else { return }
        print("Now: \(Date().formatted(.dateTime.month().day().hour().minute().second()))")
        if endTime >= Date() {
            print("not elapsed")
            elapsed = false
        }else {
            print("elapsed")
            elapsed = true
        }
        
        elapsedTime += 1
        print("elapsed time: \(elapsedTime)")
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
        print("progress: \(progress)")
    }
}
