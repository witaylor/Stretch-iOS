//
//  StretchDetailView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 26/02/2021.
//

import SwiftUI
import AVKit

struct StretchDetailView: View {
  @State var stretch: Stretch
  
  @State private var isPerformingStretch = false
  @State private var isShowingStretchSource = false
  
  @State private var stretchSetsToPerform = 2
  
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
  
  // ensures a different colour for the source to the body part
  private func sourceLinkColour(for stretch: Stretch) -> Color {
    switch iconColour(for: stretch) {
      case .iconBG_blue:
        return .iconBG_orange
      case .iconBG_green:
        return .iconBG_purple
      case .iconBG_orange:
        return .iconBG_blue
      case .iconBG_purple:
        return .iconBG_green
      default:
        return .iconBG_blue
    }
  }
  
  var body: some View {
    VStack {
      ScrollView {
        // guide
        StretchGuideView(stretch: stretch)
        
        // info
        VStack {
          HStack {
            ZStack {
              Circle()
                .fill(iconColour(for: stretch))
                .frame(width: 24, height: 24)
              
              Image(iconName(for: stretch))
                .resizable()
            }.frame(width: 32, height: 32)
            
            Text("For your \(stretch.bodyPart.rawValue)")
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          
          Link(destination: URL(string: stretch.source.url)!) {
            HStack {
              ZStack {
                Circle()
                  .fill(sourceLinkColour(for: stretch))
                  .frame(width: 24, height: 24)
                
                Image(systemName: "link")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("View on \(stretch.source.name)")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
        }.padding(.vertical)
      }
      
      Spacer()
      
      // start stretching
      PrimaryButton(
        label: "Start stretching",
        action: {
          HapticManager.mediumTap()
          isPerformingStretch = true
          
          DataManager.shared.startTotalStretchTimer()
        }
      )
    }.padding(.horizontal)
    .padding(.bottom)
    .navigationTitle(stretch.name)
    .sheet(isPresented: $isPerformingStretch) {
      NavigationView {
        VStack(alignment: .leading, spacing: 20) {
            Text("How many sets would you like to do?")
              .font(.headline)
            Stepper("\(stretchSetsToPerform) \(stretchSetsToPerform > 1 ? "sets" : "set")", value: $stretchSetsToPerform)
          
          NavigationLink(
            destination: StretchRepView(
              stretchRoutine: StretchRoutine(
                totalStretches: 1,
                estimatedDurationMinutes: 1,
                stretches: [PerformableStretch(
                  stretch: self.stretch,
                  sets: stretchSetsToPerform,
                  reps: self.stretch.type == .timed ? 15 : 10,
                  completed: false
                )]),
              onRoutineComplete: { updatedRoutine in
                DataManager.shared.saveAdditionalStretches(updatedRoutine)
                DataManager.shared.endTotalStretchTimer()
                
                self.isPerformingStretch = false
              },
              shouldShowStreakExtended: false)) {
            Text("Start stretching")
              .foregroundColor(Color.white)
              .fontWeight(.semibold)
          }.frame(maxWidth: .infinity)
          .padding(.horizontal, 20)
          .padding(.vertical, 10)
          .background(Color.accentGreen)
          .cornerRadius(4)
        }.padding()
        .background(Color.lightGrey)
        .cornerRadius(10)
        .padding()
      }
    }
  }
}
