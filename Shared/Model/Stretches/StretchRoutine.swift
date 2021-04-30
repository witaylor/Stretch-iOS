//
//  StretchRoutine.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

// routine of stretches presented to the user
struct StretchRoutine: Codable, Hashable {
  var totalStretches: Int
  var estimatedDurationMinutes: Int // minutes
  var stretches: [PerformableStretch]
  var isComplete: Bool = false
}
