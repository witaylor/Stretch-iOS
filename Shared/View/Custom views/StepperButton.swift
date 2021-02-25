//
//  StepperButton.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 25/02/2021.
//

import SwiftUI

enum StepperButtonType {
  case increment, decrement
}

struct StepperButton: View {
  let type: StepperButtonType
  @Binding var value: Int
  var limit: Int? = nil

  private var buttonImageName: String {
    "\(type == .increment ? "plus" : "minus").circle.fill"
  }

  private func fire() {
    if type == .increment &&
      limit == nil || (limit != nil) && value < limit! {
        self.value += 1
    }
    else if type == .decrement &&
      limit == nil || (limit != nil) && value > limit! {
        self.value -= 1
    }
  }

  var body: some View {
    Button(action: { fire() }) {
      ZStack {
        Circle()
          .fill(Color.black)

        Image(systemName: buttonImageName)
          .resizable()
          .accentColor(Color.white)
      }
    }.frame(width: 32, height: 32)
    .cornerRadius(100)
  }
}
