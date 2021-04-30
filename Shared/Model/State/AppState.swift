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
  
  func dailyStreak() -> DailyStreak {
    let dateKeys: [Date] = [
      Date(),
      Date().subtractDays(1),
      Date().subtractDays(2),
      Date().subtractDays(3),
      Date().subtractDays(4)
    ]
  
    let streakDays: [StreakDay] = dateKeys.map {
      StreakDay(
        date: $0,
        stretchCompleted: findStretchDayForDate($0)?.stretchRoutine.isComplete
          ?? false
      )
    }
    
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
    guard let months = userInfo?.userStretchHistory,
          months.count > 0 else { return 0 }
    var allDays = months.flatMap { (sm: StretchMonth) in
      sm.days
    }
    var streakLength = 0
    
    // check if today is complete, if not remove it
    if let today = allDays.last {
      if !today.stretchRoutine.isComplete {
        allDays.removeLast()
      }
    }
    allDays.forEach {
      if $0.stretchRoutine.isComplete {
        streakLength += 1
      } else {
        streakLength = 0
      }
    }
    
    return streakLength
  }
  
  /// Returns the end date of the study
  func studyEndDate() -> Date {
    if let info = userInfo {
      // sort early first
      let sortedStretchHistory = info
        .userStretchHistory
        .sorted { $0.year < $1.year ||
          $0.year == $1.year && $0.month < $1.month }
      // get first day where stretch completed
      if let firstDayWhereCompleted = sortedStretchHistory
          .first?
          .days
          .sorted(by: { $0.date < $1.date })
          .first(where: { (d1: StretchDay) -> Bool in
            d1.stretchRoutine.isComplete
          }) {
        // return date + 7 days
        return Calendar.current.date(
          byAdding: .day,
          value: 7,
          to: firstDayWhereCompleted.date
        )!
      }
    }
    // return todays date and assume study in progress
    return Date()
  }
}
