//
//  PerformableStretch.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

// stretch that user can perform
struct PerformableStretch: Codable, Hashable {
  var stretch: Stretch
  var sets: Int
  var reps: Int // time/reps based on stretch.type
  var completed: Bool
  
  mutating func complete() {
    self.completed = true
  }
}
