//
//  HideKeyboard.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 04/03/2021.
//

import SwiftUI

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif
