//
//  StretchBulletView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct StretchBulletView: View {
  var isComplete: Bool = false
  var color: Color? = nil
  
  private func bulletColor() -> Color {
    color ?? (isComplete ? Color.accentGreen : Color.black)
  }
  
  var body: some View {
    ZStack {
      Circle()
        .fill(bulletColor())
        .frame(height: 16)
      
      Circle()
        .fill(Color.white)
        .frame(height: 6)
    }.frame(width: 16)
  }
}
