//
//  RateDiscomfortView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 25/02/2021.
//

import SwiftUI

let MAX_DISCOMFORT_RATING = 10

struct RateDiscomfortView: View {
  @State private var discomfortLevel: Int = 5
  @State private var ratingSubmitted: Bool = false
  var submitRatingFunction: (_: Int) -> Bool

  init(submitRatingFunction: @escaping (_: Int) -> Bool) {
    self.submitRatingFunction = submitRatingFunction
  }

  var body: some View {
    VStack {
      VStack {
        Text("Rate your discomfort levels")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)

        HStack {
          StepperButton(type: .decrement, value: $discomfortLevel, limit: 0)

          HStack {
            Text("\(discomfortLevel)")
              .fontWeight(.semibold)
              .font(.system(size: 96, design: .rounded))

            Text("/10")
              .fontWeight(.light)
          }.frame(maxWidth: .infinity)

          StepperButton(type: .increment, value: $discomfortLevel, limit: MAX_DISCOMFORT_RATING)
        }

        Button(action: { self.ratingSubmitted = submitRatingFunction(discomfortLevel) }) {
          Text("Submit")
            .foregroundColor(Color.white)
            .fontWeight(.semibold)
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(ratingSubmitted ? Color.accentGreen.opacity(0.5) : Color.accentGreen)
        .cornerRadius(5)
      }.padding(20)
    }.background(ratingSubmitted ? Color.gray : Color.accentGreen.opacity(0.1))
    .cornerRadius(20)
  }
}

struct RateDiscomfortView_Previews: PreviewProvider {
    static var previews: some View {
      RateDiscomfortView(submitRatingFunction: { i in return false })
    }
}
