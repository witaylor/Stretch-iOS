//
//  TodaysStretchesView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct TodaysStretchesView: View {
  @Binding var stretchRoutine: StretchRoutine
  @State private var routineShowing = false

  var showRoutine: () -> ()

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Today's stretches")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)

        HStack {
          Image("stopwatch")
            .resizable()
            .frame(width: 21, height: 21)
          Text("\(stretchRoutine.estimatedDurationMinutes) min")
        }.opacity(0.3)
      }

      VStack(spacing: 15) {
        if stretchRoutine.totalStretches <= 3 {
          // list all stretches
          ForEach(stretchRoutine.stretches, id: \.stretch.id) { perfStretch in
            HStack {
              StretchBulletView(isComplete: perfStretch.completed)
              Text(perfStretch.stretch.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        } else {
          // list first 2 with a count of remaining stretches
          ForEach(stretchRoutine.stretches.prefix(2), id: \.stretch.id) { perfStretch in
            HStack {
              StretchBulletView(isComplete: perfStretch.completed)
              Text(perfStretch.stretch.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }

          HStack {
            StretchBulletView(isComplete: false)
            Text("+ \(stretchRoutine.totalStretches - 2) more")
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundColor(Color.gray)
          }
        }
      }

      Button(action: { showRoutine() }) {
        Text("Start stretching")
          .foregroundColor(Color.white)
          .fontWeight(.semibold)
      }.frame(maxWidth: .infinity)
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
      .background(stretchRoutine.isComplete ? Color.accentGreen.opacity(0.5) : Color.accentGreen)
      .cornerRadius(4)
    }
  }
}
