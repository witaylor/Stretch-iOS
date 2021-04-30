//
//  NavigationButton.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 26/03/2021.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
  var destination: Destination
  @Binding var isActive: Bool
  var label: String
  
  var foregroundColor: Color? = .white
  var backgroundColor: Color? = .accentGreen
  
    var body: some View {
      NavigationLink(
        destination: destination,
        isActive: $isActive,
        label: {
          Text(label)
            .foregroundColor(foregroundColor)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(backgroundColor)
            .cornerRadius(4)
        })
    }
}
