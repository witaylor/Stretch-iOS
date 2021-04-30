//
//  SetupProfileView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 04/03/2021.
//

import SwiftUI

struct SetupProfileView: View {
  var onComplete: (String, String, Int) -> ()
  
  @State private var userNameString: String = ""
  @State private var userEmailString: String = ""
  @State private var userStepGoalString: String = ""
  
  @State private var errorAlertShowing = false
  
  private func textFieldBackground(for string: String) -> some View {
    // min goal of 100 steps
    if string.count > 0 {
      return RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.accentGreen.opacity(0.1))
    } else {
      return RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.lightGrey)
    }
  }
  
  private func stepGoalTextFieldBackground() -> some View {
    // min goal of 100 steps
    if let stepGoal = Int(userStepGoalString), stepGoal > 0 {
      return RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.accentGreen.opacity(0.1))
    } else {
      return RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.lightGrey)
    }
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 20) {
        VStack(alignment: .leading, spacing: 10) {
          Text("👋 Tell me about yourself")
            .font(.headline)
            .padding(.bottom, 5)
          Text("Before you can begin building a better posture, I need to know some things about you.")
        }
        
        VStack(alignment: .leading, spacing: 10) {
          Text("What shall I call you?")
          TextField("Stretchy", text: $userNameString)
            .textContentType(.givenName)
            .padding()
            .background(textFieldBackground(for: userNameString))
            .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 10) {
          Text("🚶‍♀️ Step count and goals")
            .font(.headline)
            .padding(.bottom, 5)
          Text("Finally, movement is essential to building and maintaining a pain-free posture, so we'd love to help you reach your step goals. Stretch needs access to your device's step count so we can congratulate you when you hit them! First, set a step goal, and then allow Stretch access to your step count.")
          
          Text("Set your step goal")
            .fontWeight(.semibold)
          
          TextField("5,000", text: $userStepGoalString)
            .keyboardType(.numberPad)
            .padding()
            .background(stepGoalTextFieldBackground())
            .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.bottom, 20)
        
        Spacer()
        
        PrimaryButton(
          label: "Start stretching",
          backgroundColor: .accentGreen,
          action: {
            HapticManager.mediumTap()
            onComplete(userNameString, userEmailString, Int(userStepGoalString) ?? 5000)
          }
        )
      }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      .onTapGesture {
        hideKeyboard()
      }
    }.padding()
    .navigationTitle("Setup Profile")
    .allowAutoDismiss(false)
    .alert(isPresented: $errorAlertShowing) {
      Alert(
        title: Text("You forgot something!"),
        message: Text("Please fill out all of the fields.")
      )
    }
  }
}
