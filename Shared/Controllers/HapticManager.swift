//
//  HapticManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 07/03/2021.
//

import Foundation
import SwiftUI

class HapticManager {
  static func mediumTap() {
    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
  }
  
  static func lightTap() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
  }
}
