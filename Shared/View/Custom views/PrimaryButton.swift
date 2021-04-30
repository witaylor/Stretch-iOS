//
//  Button.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 26/03/2021.
//

import SwiftUI

struct PrimaryButton: View {
  var label: String
  var foregroundColor: Color = .white
  var backgroundColor: Color = .accentGreen
  var fontWeight: Font.Weight = .semibold
  var action: () -> ()
  
  var body: some View {
    Button(action: action) {
      Text(label)
        .foregroundColor(foregroundColor)
        .fontWeight(fontWeight)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(backgroundColor)
        .cornerRadius(4)
    }
  }
}
