//
//  EndOfStudyNotificationView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 07/03/2021.
//

import SwiftUI

struct EndOfStudyNotificationView: View {
  @State private var alertContent: Alert = Alert(title: Text("Alert!"))
  @State private var isAlertShowing = false
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Study has ended!")
        .font(.title2)
        .fontWeight(.semibold)
        .padding(.bottom, 5)
      
      Text("Thank you for taking part in my dissertation study. If you would like to do so, you can continue to use Stretch to help you build a better posture. But before you do anything else, I need you to share some data with me so I can analyse the results. All you need to do is tap below.")
      
      PrimaryButton(
        label: "Share data",
        action: {
          HapticManager.mediumTap()
          
          if let errorAlert = MailManager.shared.sendStudyData() {
            alertContent = errorAlert
            isAlertShowing = true
          } else {
            // no error
            DataManager.shared.updateUserInfo(dataSubmissionDate: Date())
          }
        }
      ).padding(.top, 20)
    }.fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.accentGreen.opacity(0.1))
    .cornerRadius(10)
    .alert(isPresented: $isAlertShowing) {
      alertContent
    }
  }
}
