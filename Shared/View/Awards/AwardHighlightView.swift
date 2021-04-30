//
//  AwardHighlightView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 05/03/2021.
//

import SwiftUI

struct AwardHighlightView: View {
  @EnvironmentObject private var appState: AppState
  
  private func getNextAward() -> Award? {
    if let firstUnachieved = appState.awardList?.first(where: {
      !$0.achieved
    }) {
      return firstUnachieved
    } else if let first = appState.awardList?.first {
      return first
    } else {
      return nil
    }
  }
  
  var body: some View {
    if let nextAward = getNextAward() {
      VStack(alignment: .leading) {
        Text("You've almost achieved another award!")
          .font(.headline)
        
        VStack(spacing: 20) {
          HStack(spacing: 10) {
            Image(nextAward.iconName)
              .resizable()
              .frame(width: 64, height: 64)
              .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
              Text(nextAward.title)
                .fontWeight(.semibold)
              
              Text(nextAward.achieved
                    ? nextAward.descriptions.complete
                    : nextAward.descriptions.incomplete
              )
            }.frame(maxWidth: .infinity, alignment: .leading)
          }.padding(.horizontal, 20)
          .padding(.vertical, 10)
          .background(Color.lightGrey)
          .cornerRadius(5)
          
          NavigationLink(destination: AwardsView()) {
            Text("See all awards")
              .padding(.horizontal, 20)
              .padding(.vertical, 10)
              .frame(maxWidth: .infinity)
              .foregroundColor(Color.white)
              .background(Color.accentGreen)
              .cornerRadius(5)
          }
        }.fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.lightGrey)
        .cornerRadius(10)
      }
    }
  }
}
