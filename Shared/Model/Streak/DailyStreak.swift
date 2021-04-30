//
//  DailyStreak.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

// should only contain the last 5 days
struct DailyStreak: Hashable {
  var lastFiveDays: [StreakDay]
  
  // length of streak - this may be longer than the number of elements in
  // lastFiveDays
  var streakLength: Int
}

// a single streak day
struct StreakDay: Hashable {
  var date: Date
  var stretchCompleted: Bool
  
  func dayString() -> String { date.dayOfWeekInitial() }
}
