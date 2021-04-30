//
//  SettingsView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 05/03/2021.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var appState: AppState
  @State private var isAlertShowing = false
  
  @State private var alertContent: Alert = Alert(
    title: Text("Error"),
    message: Text("Something went wrong, please try again")
  )
  
  private func footerView() -> some View {
    var versionString = ""
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      versionString += "version \(appVersion)"
    }
    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      versionString += ", build \(buildNumber)."
    }
    
    return VStack(alignment: .leading) {
      Text("Stretch \(versionString)")
        .font(.caption)
      Text("Copyright © 2021, Will Taylor")
        .font(.caption2)
    }
  }
  
  var body: some View {
    List {
      Section {
        NavigationLink(destination:
                        EditDetailView(
                          navTitle: "Edit name",
                          currentValue: appState.userInfo?.name ?? "What should I call you?",
                          onSubmit: {
                            DataManager.shared.updateUserInfo(name: $0)
                          }
                        )
        ) {
          Text("Change your name")
        }
        
        NavigationLink(destination: EditDetailView(
                        navTitle: "Edit goal",
                        currentValue: "\(appState.userInfo?.stepGoal ?? 5000)",
                        onSubmit: { countString in
                          DataManager.shared.updateUserInfo(
                            stepGoal: Int(countString)
                          )
                        },
                        keyboardType: .numberPad)
        ) {
          Text("Change step goal")
        }
      }
      
      Section {
        NavigationLink(destination: GetConsentView(
          consentCallback: {_,_,_,_ in }, viewOnly: true
        )
        ) {
          Text("View consent agreement")
        }
        NavigationLink(destination: ReferenceView()) {
          Text("View references")
        }
      }
      
      Section(footer: footerView()) {
        Button(action: {
          HapticManager.mediumTap()
          if let errorAlert = MailManager.shared.sendStudyData() {
            alertContent = errorAlert
            isAlertShowing = true
          }
        }) {
          Text("Send study data")
        }
      }
    }.listStyle(InsetGroupedListStyle())
    .navigationTitle("Settings")
    .alert(isPresented: $isAlertShowing) {
      alertContent
    }
  }
}
