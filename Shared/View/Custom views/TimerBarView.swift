//
//  TimerBarView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 01/03/2021.
//

import SwiftUI

struct TimerBarView: View {
  @Binding var value: CGFloat
  var endValue: Int
  
  func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
    let frame = geometry.frame(in: .global)
    return frame.size.width * value
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack(alignment: .leading) {
          Rectangle()
            .fill(Color.lightGrey)
          Rectangle()
            .fill(Color.accentGreen)
            .frame(
              minWidth: 0,
              idealWidth: getProgressBarWidth(geometry: geometry),
              maxWidth: getProgressBarWidth(geometry: geometry)
            )
            .animation(.easeInOut)
        }.frame(height: 20)
        .cornerRadius(20)
        
        HStack {
          Text("0")
          Spacer()
          Text(String(endValue))
        }
      }.frame(minHeight: 0)
    }
  }
}
