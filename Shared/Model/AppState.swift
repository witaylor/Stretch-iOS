//
//  AppState.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

class AppState: ObservableObject {
  @Published var stretchList: [Stretch]? = nil
  @Published var userInfo: UserProfile? = nil
  @Published var awardList: [Award]? = nil
  @Published var todaysRoutine: StretchRoutine!
  
//  @Published dailyStreak: DailyStreak = {
//
//  }
  
  // TODO: test this
  func dailyStreak() -> DailyStreak {
    // generate dates to use as keys
    let dateKeys: [Date] = [
      Date(),
      Date().subtractDays(1),
      Date().subtractDays(2),
      Date().subtractDays(3),
      Date().subtractDays(4)
    ]
    
    // map to StreakDays
    let streakDays: [StreakDay] = dateKeys.map {
      StreakDay(
        date: $0,
        stretchCompleted: findStretchDayForDate($0)?.stretchRoutine.isComplete
          ?? false
      )
    }
    
    // buld DailyStreak
    return DailyStreak(
      lastFiveDays: streakDays,
      streakLength: getStreakLength()
    )
  }
  
  private func findStretchDayForDate(_ dateKey: Date) -> StretchDay? {
    guard let months = userInfo?.userStretchHistory else { return nil }
    
    if let day = months.first?.days.first(where: {
      $0.date.isSameDate(as: dateKey)
    }) {
       return day
    } else if months.count > 1, let day = months[1].days.first(where: {
      $0.date.isSameDate(as: dateKey)
    }) {
      return day
    } else {
       return nil
    }
  }
  
  private func getStreakLength() -> Int {
    var streakLen = 0
    var streakEnded = false
    guard let months = userInfo?.userStretchHistory else { return 0 }
    
    var monthCounter = months.count - 1
    if monthCounter < 1 { return 0 }
    
    while monthCounter >= 0 && !streakEnded {
      let days = months[monthCounter].days
      var dayCounter = days.count - 1
      
      while dayCounter >= 0 && !streakEnded {
        if days[dayCounter].stretchRoutine.isComplete {
          streakLen += 1
        } else {
          streakEnded = true
        }
        dayCounter -= 1
      }
      
      monthCounter -= 1
    }
    return streakLen
  }
}
