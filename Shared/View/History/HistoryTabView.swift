//
//  HistoryTabView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import SwiftUI

struct HistoryTabView: View {
  @EnvironmentObject var appState: AppState
  var startStretchingFunction: () -> ()
  
  var body: some View {
    NavigationView {
      VStack {
        if let history = appState.userInfo?.userStretchHistory.reversed(),
           history.count > 0 {
          ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
              ForEach(history, id: \.self) {
                MonthHistoryView(stretchMonth: $0)
              }
            }
          }
        } else {
          EmptyHistoryView(stretchFunction: startStretchingFunction)
        }
      }.padding(.horizontal)
      .navigationTitle("History")
    }
  }
}
