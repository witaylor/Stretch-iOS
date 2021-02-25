//
//  StretchDay.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct StretchDay: Codable {
  var date: Date
  var stretchRoutine: StretchRoutine
  var discomfortRating: Int = -1 // -1 if not submitted

  var dateString: String {
    date.dateWithOrdinal()
  }
}
