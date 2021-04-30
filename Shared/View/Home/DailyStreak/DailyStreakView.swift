//
//  DailyStreakView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

import SwiftUI

struct DailyStreakView: View {
  @EnvironmentObject var appState: AppState
  @State var forStreak: DailyStreak? = nil
  
  private var userName: String? {
    appState.userInfo?.name
  }
  private var streak: DailyStreak {
    forStreak ?? appState.dailyStreak()
  }
  var showText: Bool = true
  
  func buildStreakMessage(_ streakCount: Int, todayComplete: Bool = false) -> String {
    let isUserNameSet = (userName != nil && userName != "")
    
    if streakCount < 1 {
      let intro = isUserNameSet ? "Hey, \(userName ?? "")! " : ""
      return "👊 \(intro)Let's start your streak today!"
    } else if !todayComplete {
      let name = isUserNameSet ? " \(userName ?? "name")," : ""
      return "🎉 Way to go,\(name) you're on a \(streakCount) day streak! Let's make it \(streakCount + 1)."
    } else {
      let name = isUserNameSet ? " \(userName ?? "name")," : ""
      return "🎉 Way to go today,\(name) you're on a \(streakCount) day streak!"
    }
  }
  
  var body: some View {
    VStack {
      if showText {
        Text(buildStreakMessage(streak.streakLength, todayComplete: streak.lastFiveDays[0].stretchCompleted))
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      HStack {
        ForEach(streak.lastFiveDays.reversed(), id: \.self) {
          StreakDayView(day: $0)
        }
      }
    }.fixedSize(horizontal: false, vertical: true)
  }
}
