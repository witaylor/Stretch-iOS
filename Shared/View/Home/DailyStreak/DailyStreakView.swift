//
//  DailyStreakView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

import SwiftUI

struct DailyStreakView: View {
  var userName: String?
  @State var streak: DailyStreak
  var showText: Bool = true

  func buildStreakMessage(_ streakCount: Int) -> String {
    let userIntro = (userName != nil && userName != "")
      ? "Hey, \(userName ?? "")! "
      : ""
    
    if streakCount < 1 {
      return "👊 \(userIntro)Let's smash your first day today!"
    } else {
      return "👊 \(userIntro)Way to go, you're on a \(streakCount) day streak! Let's make it \(streakCount + 1)."
    }
  }

  var body: some View {
    VStack {
      if showText {
        Text(buildStreakMessage(streak.streakLength))
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

struct DailyStreakView_Previews: PreviewProvider {
    static var previews: some View {
      DailyStreakView(
        streak: DailyStreak(
          lastFiveDays: [
            StreakDay(date: Date(), stretchCompleted: false),
            StreakDay(date: Date(), stretchCompleted: true),
            StreakDay(date: Date(), stretchCompleted: true),
            StreakDay(date: Date(), stretchCompleted: false),
            StreakDay(date: Date(), stretchCompleted: true)
          ],
          streakLength: 2
        )
      ).padding()
    }
}
