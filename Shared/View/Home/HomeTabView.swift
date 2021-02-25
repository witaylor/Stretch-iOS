//
//  HomeView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct HomeTabView: View {
  @EnvironmentObject var appState: AppState
  @State var todaysRoutine: StretchRoutine
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        LazyVStack(spacing: 50) {
          DailyStreakView(
            userName: appState.userInfo?.name,
            streak: appState.dailyStreak()
          )
          
          TodaysStretchesView(
            stretchRoutine: $todaysRoutine,
            showRoutine: { print("SHOWING ROUTINE") }
          )
          
          RateDiscomfortView(submitRatingFunction: { rating in
            print("-- submitted discomort rating of \(rating)")
            return true
          })
          
          ActivityView(stepCount: 2456, stepGoal: 10000)
          
          // AWARDS HIGHLIGHT
          
          VStack(spacing: 20) {
            Text("Awards")
              .font(.headline)
            
            Text("- show award the user is closest to earning")
            Text("- make it nice and visual (award icon etc)")
            
            Button(action: {}) {
              Text("See all awards")
            }.padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentGreen)
            .cornerRadius(5)
          }.fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.gray.opacity(0.15))
          .cornerRadius(10)
          
        }.padding()
      }.navigationTitle("Stretch")
    }
  }
}
