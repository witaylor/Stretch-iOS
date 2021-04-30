//
//  Color.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

extension Color {
  static let black = Color.black
  static let white = Color.white
  
  static let gold = Color("Gold")
  
  static let accentGreen = Color("AC_Green")
  static let accentRed = Color.red
  static let paleOrange = Color("AC_PaleOrange")
  
  static let lightGrey = Color("BG_LightGrey")
  static let darkGrey = Color.gray
  
  static let iconBG_blue = Color("Icon_bg_blue")
  static let iconBG_orange = Color("Icon_bg_orange")
  static let iconBG_purple = Color("Icon_bg_purple")
  static let iconBG_green = Color.accentGreen.opacity(0.2)
  
  static let text_lightBlue = Color("Text_LightBlue")
  static let text_lightGreen = Color("Text_LightGreen")
  static let text_lightOrange = Color("Text_LightOrange")
}
