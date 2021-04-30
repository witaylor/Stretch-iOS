//
//  StretchDay.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct StretchDay: Codable, Hashable {
  var date: Date
  var stretchRoutine: StretchRoutine
  // extra stretching done by the user
  var additionalStretches: [PerformableStretch]?
  var discomfortRating: Int = -1 // -1 if not submitted

  var dateString: String {
    date.dateWithOrdinal()
  }
}
