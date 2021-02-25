//
//  StretchBulletView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct StretchBulletView: View {
  var isComplete: Bool = false

  var body: some View {
    ZStack {
      Circle()
        .fill(isComplete ? Color.accentGreen : Color.black)
        .frame(height: 16)

      Circle()
        .fill(Color.white)
        .frame(height: 6)
    }.frame(width: 16)
  }
}

struct StretchBulletView_Previews: PreviewProvider {
    static var previews: some View {
        StretchBulletView(isComplete: false)
    }
}
