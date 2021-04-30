//
//  UserInfo.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct UserProfile: Codable {
  var name: String
  var emailAddress: String
  var userId: UUID // unique id for a user
  var hasGivenConsent: Bool // MUST be true before continuing to app
  var stepGoal: Int
  var userStretchHistory: [StretchMonth]
  var awardsEarned: [UUID] // ids of the awards the user has unlocked
  var lastSharedStudyData: Date? = nil
  var studyDates: StudyDates
}

struct StudyDates: Codable {
  var start: Date? = nil
  var end: Date? = nil
}
