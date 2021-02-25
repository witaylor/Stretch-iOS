//
//  StretchMonth.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct StretchMonth: Codable {
  var month: Int
  var year: Int

  var monthName: String {
    ["January", "February", "March", "April", "May", "June", "July", "August",
     "September", "October", "November", "December"][self.month - 1]
  }
  
  var totalDaysStretched: Int
  var avgDiscomfort: Float
  
  var days: [StretchDay]
}
