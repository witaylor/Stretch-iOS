//
//  StretchMonth.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct StretchMonth: Codable, Hashable {
  var month: Int
  var year: Int
  
  var monthName: String {
    ["January", "February", "March", "April", "May", "June", "July", "August",
     "September", "October", "November", "December"][self.month - 1]
  }
  
  var totalDaysStretched: Int {
    self.days.filter {
      $0.stretchRoutine.isComplete
    }.count
  }
  var avgDiscomfort: Int {
    let daysWithRatings = self.days.filter {
      $0.discomfortRating >= 0
    }
    let numOfDays = daysWithRatings.count > 0
      ? daysWithRatings.count
      : 1
    let avg = daysWithRatings.reduce(0) {
      $0 + $1.discomfortRating
    } / numOfDays
    
    return avg >= 0 ? avg : 0
  }
  
  var days: [StretchDay]
}
