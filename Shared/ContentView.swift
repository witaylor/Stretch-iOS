//
//  ContentView.swift
//  Shared
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

enum TitleType { case large, inline }

struct ContentView: View {
  @State private var selectedTab = 0
  
  @StateObject var appState = DataManager.shared.getAppState()
  
  
  init() {
    let appearance = UINavigationBar.appearance()
    appearance.largeTitleTextAttributes = [.font: buildFont(forTitle: .large)]
    appearance.titleTextAttributes = [.font: buildFont(forTitle: .inline)]
  }
  
  private func buildFont(forTitle titleType: TitleType) -> UIFont {
    let fontSize: CGFloat = titleType == .large ? 40 : 20
    let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    let roundedFont: UIFont
    if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
      roundedFont = UIFont(descriptor: descriptor, size: fontSize)
    } else {
      roundedFont = systemFont
    }
    
    return roundedFont
  }
  
  var body: some View {
    TabView(selection: $selectedTab) {
      HomeTabView(todaysRoutine: appState.todaysRoutine)
        .tabItem {
          Text("Home")
          Image(systemName: selectedTab == 0 ? "house.fill" : "house")
        }.tag(0)
      StretchTabView()
        .tabItem { Text("Stretch") }
        .tag(1)
      HistoryTabView()
        .tabItem {
          Text("History")
          Image(systemName: selectedTab == 2 ? "clock.fill" : "clock")
        }
        .tag(2)

//      Maybe have awards as a section on the home page?????
//      4 tabs looks cramped
//      AwardsTabView()
//        .tabItem { Text("Awards") }
//        .tag(3)
    }.font(.system(.body, design: .rounded))
    .environmentObject(appState)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
