//
//  EmptyHistoryView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 26/02/2021.
//

import SwiftUI

struct EmptyHistoryView: View {
  var stretchFunction: () -> ()
  
  var body: some View {
    VStack(spacing: 40) {
      Text("No history")
        .font(.title)
      
      PrimaryButton(
        label: "Start stretching now",
        action: {
          HapticManager.mediumTap()
          stretchFunction()
        }
      )
    }
  }
}
