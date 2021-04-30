//
//  EditStretchNotificationsView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 06/03/2021.
//

import SwiftUI

struct EditStretchNotificationsView: View {
  @State var sendReminders = true
  @State var notificationTime: Date
  var onSubmit: (Bool, Date) -> ()
  
  var body: some View {
    List {
      Section {
        Toggle(isOn: $sendReminders) {
          Text("Send me reminders")
        }
        
        DatePicker(
          "Notification time",
          selection: $notificationTime,
          displayedComponents: .hourAndMinute
        ).disabled(!sendReminders)
      }
    }.listStyle(InsetGroupedListStyle())
    .navigationTitle("Reminders")
    .onChange(of: notificationTime) { _ in
      onSubmit(sendReminders, notificationTime)
    }
    .onChange(of: sendReminders) { _ in
      onSubmit(sendReminders, notificationTime)
    }
  }
}
