//
//  ActivityView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 25/02/2021.
//

import SwiftUI

struct ActivityView: View {
  var stepCount: Int
  var stepGoal: Int
  
  func formatStepCount(_ count: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: count))
    return formattedNumber ?? "\(count)"
  }
  
  func getMotivationMesage(steps: Int, goal: Int) -> String {
    let percentGoal: Double = (Double(steps) / Double(goal)) * 100
    
    if percentGoal < 10 {
      return "🚶 Make time to walk around today. We're building a better posture, one step at a time."
    }
    else if percentGoal < 25 {
      return "🎉 Your making progress on your goal today. Let's get the steps in."
    } else if percentGoal < 50 {
      return "🎯 You're almost halfway to your goal! Let's keep moving."
    }
    else if percentGoal < 75 {
      return "🔥 Great work, you're over halfway to your goal! Keep it up."
    }
    else if percentGoal < 100 {
      return "💪 Keep it up, you're over three-quaters of the way to your goal! One last push."
    }
    else if percentGoal < 200 {
      return "🚀 Amazing! You've passed your goal for today. Time to celebrate."
    } else {
      return "🚀 Wow, you've doubled your goal! Fantastic effort today."
    }
  }
  
  private func progressToStepGoal() -> CGFloat {
    CGFloat(stepCount / stepGoal)
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Your activity")
        .font(.headline)
      
      VStack(spacing: 20) {
        VStack {
          Text(formatStepCount(stepCount))
            .font(.system(size: 42, design: .rounded))
            .fontWeight(.semibold)
          Text("steps")
        }
        
        VStack {
          Text(getMotivationMesage(steps: stepCount, goal: stepGoal))
        }
      }.fixedSize(horizontal: false, vertical: true)
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color.lightGrey)
      .cornerRadius(10)
    }
  }
}
