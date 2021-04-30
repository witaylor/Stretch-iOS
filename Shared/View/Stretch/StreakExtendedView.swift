//
//  StreakExtendedView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 05/03/2021.
//

import SwiftUI

struct StreakExtendedView: View {
  var onDismiss: () -> ()

  var body: some View {
    VStack(spacing: 10) {
      Image("Flame")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(30)
        .background(
          Circle()
            .fill(Color.orange)
        )
        .clipped()
        .padding(.horizontal, 50)
      
      Text("Great effort today! That's another day closer to better posture.")
        .font(.system(.headline, design: .rounded))
        .multilineTextAlignment(.center)
        .padding(.top, 20)
      
      Spacer()
      
      PrimaryButton(
        label: "Continue",
        action: {
          HapticManager.mediumTap()
          onDismiss()
        }
      )
    }.padding(.horizontal)
    .padding(.bottom)
    .navigationBarBackButtonHidden(true)
  }
}
