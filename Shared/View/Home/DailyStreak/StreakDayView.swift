//
//  StreakDayView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct StreakDayView: View {
  var day: StreakDay

  var body: some View {
    VStack {
      ZStack {
        Circle()
          .fill(day.stretchCompleted ? Color.accentGreen : Color.gray)
          .frame(height: 32)
          .frame(maxWidth: .infinity)

        if day.stretchCompleted {
          Image(systemName: "checkmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.white)
            .frame(width: 16.0, height: 16.0)
        }
      }

      Text(day.dayString())
        .foregroundColor(Color.gray)
    }
  }
}
struct StreakDayView_Previews: PreviewProvider {
    static var previews: some View {
      StreakDayView(day: StreakDay(date: Date(), stretchCompleted: true))
    }
}
