//
//  Stretch.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

// Base stretch object
// no user-specific info should be here
struct Stretch: Codable, Identifiable {
  var id: UUID
  var name: String
  var guide: StretchGuide
  var bodyPart: StretchBodyPart
  var source: String
  var type: StretchType
}

enum StretchBodyPart: String, Codable {
  // String value is implicit, neck -> "neck"
  case neck, shoulder, back, leg, fullBody
}

enum StretchType: String, Codable {
  case repBased, timed
}

struct StretchGuide: Codable {
  var text: [String]
  var videoName: String?
}
