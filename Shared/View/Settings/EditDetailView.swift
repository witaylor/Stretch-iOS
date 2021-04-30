//
//  EditDetailView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 05/03/2021.
//

import SwiftUI

struct EditDetailView: View {
  var navTitle: String
  var currentValue: String
  var onSubmit: (String) -> ()
  var keyboardType: UIKeyboardType = .default
  
  @State private var newValue = ""
  @State private var showingSuccessAlert = false
  
  var body: some View {
    VStack(spacing: 20) {
      TextField(currentValue, text: $newValue)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(keyboardType)
      
      PrimaryButton(
        label: "Submit",
        action: {
          HapticManager.mediumTap()
          onSubmit(newValue)
          showingSuccessAlert = true
        }
      )
      
      Spacer()
    }.padding()
    .navigationTitle(navTitle)
    .alert(isPresented: $showingSuccessAlert) {
      Alert(
        title: Text("Success!"),
        message: Text("Your settings have been updated.")
      )
    }
  }
}
