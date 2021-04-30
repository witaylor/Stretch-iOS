//
//  RateDiscomfortView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 25/02/2021.
//

import SwiftUI

let MAX_DISCOMFORT_RATING = 10

struct RateDiscomfortView: View {
  @State var discomfortRating: Int = 5 // start at the middle (0-10)
  private var ratingSubmitted: Bool = false
  var submitRatingFunction: (_: Int) -> Bool
  
  @State private var isExplainerAlertShowing = false
  @State private var isHighSubmissionAlertShowing = false
  
  init(
    submitRatingFunction: @escaping (Int) -> (Bool)
  ) {
    self.submitRatingFunction = submitRatingFunction
    
    let currentRating = DataManager.shared.getDiscomfortRating()
    self.ratingSubmitted = currentRating >= 0
    self.discomfortRating = self.ratingSubmitted
      ? currentRating
      : 9
  }
  
  var body: some View {
    VStack {
      VStack {
        HStack {
          Text("Rate your discomfort level")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Button(action: { isExplainerAlertShowing = true }) {
            Image(systemName: "questionmark.circle.fill")
              .accentColor(Color.darkGrey)
              .font(.headline)
          }.frame(maxWidth: 32, maxHeight: 32)
          .alert(isPresented: $isExplainerAlertShowing, content: {
            Alert(
              title: Text("Discomfort rating"),
              message: Text("Rate how much discomfort you've felt today. 0 is no discomfort, and 10 is severe pain, with a steady scale in between. If you rate your discomfort a 7 or over, then you should consider consulting a health professional.")
            )
          })
        }
        
        Text("Did you feel any discomfort when sitting today?")
          .font(.caption)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
          StepperButton(type: .decrement, value: $discomfortRating, limit: 0)
          
          HStack {
            Text("\(discomfortRating)")
              .fontWeight(.semibold)
              .font(.system(size: 96, design: .rounded))
            
            Text("/10")
              .fontWeight(.light)
          }.frame(maxWidth: .infinity)
          
          StepperButton(type: .increment, value: $discomfortRating, limit: MAX_DISCOMFORT_RATING)
        }
        
        PrimaryButton(
          label: "Submit",
          backgroundColor: ratingSubmitted ? Color.accentGreen.opacity(0.5) : Color.accentGreen,
          action: {
            HapticManager.lightTap()
            _ = submitRatingFunction(discomfortRating)
            
            if discomfortRating >= 7 {
              isHighSubmissionAlertShowing = true
            }
          }
        ).alert(isPresented: $isHighSubmissionAlertShowing, content: {
          Alert(
            title: Text("High discomfort rating"),
            message: Text("""
                            You've submitted a high discomfort rating. If you have any of the following symptoms, then please stop using Stretch and consult a health professional.

                            Pins and needles
                            Numbness
                            Any loss of feeling
                            Headaches

                            If you are experiencing any of these symtoms, stretching may make it worse. Please stop using the app and consult a health professional.
                          """)
          )
        })
      }.padding(20)
    }.background(ratingSubmitted ? Color.lightGrey : Color.accentGreen.opacity(0.1))
    .cornerRadius(20)
  }
}
