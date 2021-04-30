//
//  StretchTabView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct StretchTabView: View {
  @EnvironmentObject var appState: AppState
  @Binding var todaysRoutine: StretchRoutine
  
  @State private var isShowingStretchRoutine = false
  
  private func iconName(for stretch: Stretch) -> String {
    switch stretch.bodyPart {
      case .back:
        return "BackIcon"
      case .fullBody:
        return "MeditationIcon"
      case .leg:
        return "LegIcon"
      case .neck:
        return "NeckIcon"
      case .shoulder:
        return "ShoulderIcon"
    }
  }
  
  private func iconColour(for stretch: Stretch) -> Color {
    switch stretch.bodyPart {
      case .back:
        return Color.iconBG_orange
      case .fullBody:
        return .iconBG_green
      case .leg:
        return .iconBG_blue
      case .neck:
        return .iconBG_green
      case .shoulder:
        return .iconBG_purple
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 10) {
          
          if !todaysRoutine.isComplete {
            VStack {
              Text("Feel like stretching? Why not complete todays routine?")
              
              TodaysStretchesView(
                stretchRoutine: $todaysRoutine,
                showRoutine: {
                  isShowingStretchRoutine = true
                  DataManager.shared.startTotalStretchTimer()
                }
              ).padding()
              .background(Color.lightGrey)
              .cornerRadius(10)
            }.padding(.vertical, 20)
          }
          
          ForEach(appState.stretchList ?? [], id: \.self) { (stretch: Stretch) in
            NavigationLink(destination: StretchDetailView(stretch: stretch)) {
              HStack {
                // icon
                ZStack {
                  Circle()
                    .fill(iconColour(for: stretch))
                    .frame(width: 24, height: 24)
                  
                  Image(iconName(for: stretch))
                    .resizable()
                }.frame(width: 32, height: 32)
                
                Text(stretch.name)
                Spacer()
                Image(systemName: "chevron.right")
              }.padding()
              .background(Color.lightGrey)
              .cornerRadius(5)
            }
          }
        }.padding(.horizontal)
        .padding(.bottom)
        .foregroundColor(.black)
      }.navigationTitle("Stretch")
      .sheet(isPresented: $isShowingStretchRoutine) {
        NavigationView {
          StretchRepView(
            stretchRoutine:  self.todaysRoutine,
            currentStretchIndex: 0,
            onRoutineComplete: { finalRoutine in
              self.isShowingStretchRoutine = false
              self.todaysRoutine = finalRoutine
              
              DataManager.shared.saveRoutineToHistory(self.todaysRoutine)
              NotificationManager.shared.setBadgeCount(to: 0)
              
              DataManager.shared.endTotalStretchTimer()
            }
          )
        }
      }
    }
  }
}
