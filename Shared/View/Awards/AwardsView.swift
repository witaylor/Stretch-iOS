//
//  AwardsTabView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct AwardsView: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("Awards aren't working yet. To show you how they work, the first one has been \"completed\" for you.")
      }.frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
      .background(Color.accentRed.opacity(0.15))
      .cornerRadius(5)
      .padding(.horizontal)
      
      LazyVStack {
        ForEach(appState.awardList ?? [], id: \.self) { (award: Award) in
          HStack(spacing: 10) {
            ZStack {
              Image(award.iconName)
                .resizable()
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fit)
              
              if award.achieved {
                VStack {
                  Spacer()
                  HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                      .resizable()
                      .foregroundColor(.accentGreen)
                      .frame(width: 24, height: 24)
                      .aspectRatio(contentMode: .fit)
                  }
                }
              }
            }.frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
              Text(award.title)
                .fontWeight(.semibold)
              
              Text(award.achieved
                    ? award.descriptions.complete
                    : award.descriptions.incomplete
              )
            }.frame(maxWidth: .infinity, alignment: .leading)
          }.padding(.horizontal, 20)
          .padding(.vertical, 10)
          .background(award.achieved
                        ? Color.gold.opacity(0.4)
                        : Color.lightGrey)
          .cornerRadius(5)
        }
      }.padding(.horizontal)
    }.navigationTitle("Awards")
  }
}
