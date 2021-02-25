//
//  UserInfo.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

struct UserProfile: Codable {
  var name: String
  var stepGoal: Int
  var stretchGoalSeconds: Int
  var userStretchHistory: [StretchMonth]
  var awardsEarned: [UUID] // ids of the awards the user has unlocked
}
