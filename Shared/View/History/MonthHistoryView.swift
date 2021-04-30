//
//  MonthHistoryView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 26/02/2021.
//

import SwiftUI

struct MonthHistoryView: View {
  var stretchMonth: StretchMonth
  
  private func monthName() -> String {
    ["January", "February", "March", "April", "May", "June", "July", "August",
     "September", "October", "November", "December"][stretchMonth.month - 1]
  }
  
  var body: some View {
    VStack {
      Text("\(monthName()) \(String(stretchMonth.year))")
        .font(.title2)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack {
        HStack {
          Text("Days stretched")
            .foregroundColor(Color.gray)
          Spacer()
          Text(String(stretchMonth.totalDaysStretched))
            .foregroundColor(Color.text_lightOrange)
        }
        
        HStack {
          Text("Avg. discomfort")
            .foregroundColor(Color.gray)
          Spacer()
          Text(String(stretchMonth.avgDiscomfort))
            .foregroundColor(Color.text_lightBlue)
        }
      }.padding(.top, 5)
      .padding(.bottom, 10)
      
      // days
      ForEach(stretchMonth.days.reversed(), id: \.self) { (day: StretchDay) in
        VStack(alignment: .leading) {
          Text(day.dateString)
            .font(.headline)
            .fontWeight(.semibold)
          
          if day.stretchRoutine.isComplete {
            VStack(alignment: .leading) {
              Text("Daily routine")
                .fontWeight(.semibold)
                .padding(.top, 5)
              
              ForEach(day.stretchRoutine.stretches, id: \.self) { (stretch: PerformableStretch) in
                HStack(alignment: .center) {
                  StretchBulletView(isComplete: stretch.completed)
                  Text(stretch.stretch.name)
                }
              }
            }
          }
          
          if let addStretches = day.additionalStretches,
             addStretches.count > 0 {
            VStack(alignment: .leading) {
              Text("Additional stretches")
                .fontWeight(.semibold)
                .padding(.top, 10)
              
              ForEach(addStretches, id: \.self) { (stretch: PerformableStretch) in
                HStack(alignment: .center) {
                  StretchBulletView(isComplete: stretch.completed)
                  Text(stretch.stretch.name)
                }
              }
            }
          }                 
          
          if !day.stretchRoutine.isComplete &&
              (day.additionalStretches?.count ?? -1 <= 0) {
            HStack(alignment: .center) {
              StretchBulletView(
                isComplete: false,
                color: Color.accentRed.opacity(0.8)
              )
              Text("No stretches completed")
            }
          }
          
          // discomfort
          HStack {
            Image("TapeMeasureIcon")
              .resizable()
              .frame(width: 21, height: 21)
            Text(day.discomfortRating >= 0
                  ? "\(day.discomfortRating)/\(MAX_DISCOMFORT_RATING) discomfort"
                  : "No rating submitted")
          }.padding(.top, 10)
        }.padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.lightGrey)
        .cornerRadius(10)
      }
    }.padding(.vertical)
  }
}
