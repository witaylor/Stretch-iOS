//
//  Award.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct Award: Codable, Hashable {
  var id: UUID
  var title: String
  var descriptions: AwardDescriptions
  var achieved: Bool
  var iconName: String
}

struct AwardDescriptions: Hashable, Codable {
  var complete: String
  var incomplete: String
}

struct CompletableAward: Hashable {
  var award: Award
  var completed: Bool
}
