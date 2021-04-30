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
  
  @State private var needUserConsent: Bool = !DataManager.shared.hasUserGivenConsent()
  
  @State var sse = true
  
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
      if !needUserConsent {
        HomeTabView(
          todaysRoutine: appState.todaysRoutine,
          dailyStreak: appState.dailyStreak()
        )
        .tabItem {
          Text("Home")
          Image(systemName: selectedTab == 0 ? "house.fill" : "house")
        }.tag(0)
        StretchTabView(todaysRoutine: $appState.todaysRoutine)
          .tabItem {
            Text("Stretch")
            Image(selectedTab == 1 ? "StretchIconFilled" : "StretchIcon")
          }
          .tag(1)
        HistoryTabView(startStretchingFunction: { self.selectedTab = 0 })
          .tabItem {
            Text("History")
            Image(systemName: selectedTab == 2 ? "clock.fill" : "clock")
          }
          .tag(2)
      } else {
        NavigationView {
          VStack(spacing: 20) {
            Text("You need to consent to using Stretch. If you have already done this, then something has gone wrong. Please try again.")
              .font(.system(.title, design: .rounded))
              .fontWeight(.bold)
            PrimaryButton(
              label: "Give consent",
              action: {
                HapticManager.mediumTap()
                needUserConsent = true
              }
            )
          }.padding()
        }
      }
    }.font(.system(.body, design: .rounded))
    .environmentObject(appState)
    .fullScreenCover(isPresented: $needUserConsent) {
      NavigationView {
        GetConsentView(consentCallback: {
          needUserConsent = !$3
          DataManager.shared.updateUserInfo(
            name: $0,
            email: $1,
            stepGoal: $2,
            givenConsent: $3
          )
        })
      }.allowAutoDismiss(false)
    }
  }
}
