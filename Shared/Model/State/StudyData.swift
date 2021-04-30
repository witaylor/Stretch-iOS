//
//  StudyData.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 08/03/2021.
//

import Foundation

struct StudyData: Codable {
  var userEmail: String
  var history: [StretchMonth]
  var steps: [StepData]? = nil
  var stepGoal: Int? = nil
  var buildData: AppBuildData? = nil
  
  init(
    userEmail: String,
    history: [StretchMonth],
    steps: [StepData]?,
    stepGoal: Int?
  ) {
    self.userEmail = userEmail
    self.history = history
    self.steps = steps
    self.stepGoal = stepGoal
    
    print("BUILDING DATA!!!")
    
    self.buildData = AppBuildData(
      version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
      build: Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    )
  }
}

struct StepData: Codable {
  var date: Date
  var stepCount: Double
}

struct AppBuildData: Codable {
  var version: String?
  var build: String?
}
