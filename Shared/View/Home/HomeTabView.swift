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
  @State var dailyStreak: DailyStreak
  
  @State private var showingStretchRoutine = false
  @State private var userStepCount: Int = 0
  
  private func shouldShowEndOfStudyNotification() -> Bool {
    let hasStudyEnded = appState.studyEndDate() < Date()
    if let lastSubmissionDate = appState.userInfo?.lastSharedStudyData {
      // if user has submitted data since the end of the study, don't show
      let hasSentDataSinceEnd = lastSubmissionDate >= appState.studyEndDate()
      return !hasSentDataSinceEnd
    }
    // user hasn't submitted any data, so show notification if study has ended
    return hasStudyEnded
  }
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        LazyVStack(spacing: 50) {
          if shouldShowEndOfStudyNotification() {
            EndOfStudyNotificationView()
          }
          
          DailyStreakView()
          
          TodaysStretchesView(
            stretchRoutine: $todaysRoutine,
            showRoutine: {
              showingStretchRoutine = true
              DataManager.shared.startTotalStretchTimer()
            }
          )
          
          RateDiscomfortView(
            submitRatingFunction: { rating in
              DataManager.shared.saveDiscomfortRating(of: rating)
              return true
            }
          )
          
          ActivityView(
            stepCount: userStepCount,
            stepGoal: appState.userInfo?.stepGoal ?? 0
          )
          
          AwardHighlightView()
        }.padding()
      }
      .navigationTitle("Stretch")
      .navigationBarItems(
        trailing:
          NavigationLink(destination: SettingsView()) {
            Image(systemName: "gearshape")
              .resizable()
          }
      )
      .sheet(isPresented: $showingStretchRoutine) {
        NavigationView {
          StretchRepView(
            stretchRoutine:  self.todaysRoutine,
            currentStretchIndex: 0,
            onRoutineComplete: { finalRoutine in
              self.showingStretchRoutine = false
              self.todaysRoutine = finalRoutine
              
              DataManager.shared.saveRoutineToHistory(self.todaysRoutine)
              NotificationManager.shared.setBadgeCount(to: 0)
              
              DataManager.shared.endTotalStretchTimer()
            }
          )
        }
      }.onAppear {
        HealthKitManager.shared.getStepCountForToday { (count: Double) in
          self.userStepCount = Int(count)
        }
      }
    }
  }
}
