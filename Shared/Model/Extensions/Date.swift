//
//  Date.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

extension Date {
  /// Returns  a component of a date, e.g. the week number
  func get(
    _ component: Calendar.Component,
    calendar: Calendar = Calendar.current
  ) -> Int {
    calendar.component(component, from: self)
  }
  
  /// Get the name of the day of the week for the date.
  /// For example, "Monday", or "Friday".
  func dayOfWeek() -> String {
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
     "Sunday"][self.get(.weekday) - 1]
  }
  
  /// Get the first letter of the day of the week for the date.
  /// For example, "M" for  "Monday".
  func dayOfWeekInitial() -> String {
    ["M", "T", "W", "T", "F", "S", "S"][self.get(.weekday) - 1]
  }
  
  /// Get the date with it's ordinal, e.g. "1st" or "23rd"
  func dateWithOrdinal() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    let ordinal = formatter.string(from: NSNumber(value: self.get(.day)))

    return "\(self.dayOfWeek()), \(String(describing: ordinal))"
  }
  
  func subtractDays(_ daysToSubtract: Int) -> Date {
    let now = Calendar.current.dateComponents(in: .current, from: Date())
    let pastComponents = DateComponents(
      year: now.year,
      month: now.month,
      day: now.day! - daysToSubtract
    )

    return Calendar.current.date(from: pastComponents)!
  }
  
  func isSameDate(as date2: Date) -> Bool {
    self.get(.day) == date2.get(.day) &&
      self.get(.month) == date2.get(.month) &&
      self.get(.year) == date2.get(.year)
  }
}
