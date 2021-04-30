//
//  GetConsentView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 01/03/2021.
//

import SwiftUI

struct GetConsentView: View {
  @State var consentCallback: (String, String, Int, Bool) -> ()
  @State private var userHasCheckedConsent = false
  @State private var noConsentAlertShowing = false
  
  @State private var shouldMoveToProfileSetup = false
  
  @State private var notificationsEnabled = false
  @State private var stepsEnabled = false
  
  var viewOnly: Bool = false
  
  private func verifyAndSendConsent(
    name: String,
    email: String,
    stepGoal: Int
  ) {
    if userHasCheckedConsent {
      consentCallback(name, email, stepGoal, userHasCheckedConsent)
      return
    }
    
    noConsentAlertShowing = true
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 20) {
        Text("Welcome to Stretch. Before you begin building a better posture, there's some things you should know.")
        
        VStack(alignment: .leading) {
          Text("⚠️ Warning")
            .font(.headline)
            .padding(.bottom, 5)
          Text("If you feel any pain while stretching or otherwise using the app, please stop what you’re doing and consult a health professional.")
        }.padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
        
        VStack(alignment: .leading) {
          Text("🔒 Data Storage")
            .font(.headline)
            .padding(.bottom, 5)
          Text("The app will keep a record of the stretches you perform, how long they take and any discomfort ratings you submit. This information is used solely for functionalities such as keeping your daily streaks and showing you your stretch history. No data will ever leave your device unless you specifically share it.")
        }
        
        VStack(alignment: .leading, spacing: 10) {
          Text("⏰ You can stop at any time")
            .font(.headline)
            .padding(.bottom, 5)
          Text("You can stop using the app at any time, for any reason. If you begin to feel any more discomfort/pain that is new or unusual, please stop using the app and consult a health professional.")
        }
        
        VStack(alignment: .leading, spacing: 10) {
          Text("📱 Permissions")
            .font(.headline)
            .padding(.bottom, 5)
          Text("Stretch would like to provide you daily reminders to keep you motivated, and show you your step count and progress towards your step goals. To do this, we need your permission. Tap the buttons below to give Stretch access. You can change this at any time from within the Settings app on your iPhone.")
            .fixedSize(horizontal: false, vertical: true)
            .padding(0)
          
          if !viewOnly {
            VStack(spacing: 5) {
              Button(action: {
                HapticManager.lightTap()
                
                NotificationManager.shared.requestPermissions()
                notificationsEnabled = true
              }) {
                HStack {
                  StretchBulletView(isComplete: notificationsEnabled)
                  Text("Enable notifications")
                    .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(notificationsEnabled
                              ? Color.accentGreen.opacity(0.1)
                              : Color.gray.opacity(0.3)
                )
                .foregroundColor(Color.black)
                .cornerRadius(5)
              }
              
              Button(action: {
                HapticManager.lightTap()
                HealthKitManager.shared.requestHealthKitAccess()
                stepsEnabled = true
              }) {
                HStack {
                  StretchBulletView(isComplete: stepsEnabled)
                  Text("Enable step count")
                    .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(stepsEnabled
                              ? Color.accentGreen.opacity(0.1)
                              : Color.gray.opacity(0.3)
                )
                .foregroundColor(Color.black)
                .cornerRadius(5)
              }
            }.padding(.vertical)
          }
          
          Text("At the end of the study, you'll need to send an email with a few things. To make this easy, there'll be a reminder on Stretch's home screen. There's also an option in settings. To do this, though, you will need to have Apple's Mail app installed on your device. If you don't already have it, please install it now.")
            .fixedSize(horizontal: false, vertical: true)
            .padding(0)
          
          if !MailManager.shared.canSendMail() {
            Link(destination: URL(string: "https://apps.apple.com/gb/app/mail/id1108187098")!) {
              HStack {
                StretchBulletView()
                Text("Install Mail")
                  .fontWeight(.semibold)
              }.padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(Color.black)
              .cornerRadius(5)
            }.padding(.vertical, 5)
          }
          
        }.padding(.bottom, 20)
        
        if !viewOnly {
          VStack(alignment: .leading) {
            Text("Finally, if you are happy with all the information outlined above, tap to give consent.")
              .font(.headline)
            
            Button(action: {
              HapticManager.lightTap()
              self.userHasCheckedConsent.toggle()
              
            }) {
              HStack {
                StretchBulletView(isComplete: userHasCheckedConsent)
                Text("I give consent")
                  .font(.title3)
                  .fontWeight(.semibold)
              }.padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(
                userHasCheckedConsent
                  ? Color.accentGreen.opacity(0.1)
                  : Color.gray.opacity(0.3)
              )
              .foregroundColor(Color.black)
              .cornerRadius(10)
            }
          }
          
          PrimaryButton(
            label: "Setup profile",
            backgroundColor: .accentGreen,
            action: {
              HapticManager.mediumTap()
              
              if userHasCheckedConsent {
                shouldMoveToProfileSetup = true
              } else {
                noConsentAlertShowing = true
              }
            }
          )
          
          // Hidden NavigationLink to move to profile view
          NavigationLink(
            destination: SetupProfileView(
              onComplete: { (name: String, email: String, stepGoal: Int) in
                verifyAndSendConsent(name: name, email: email, stepGoal: stepGoal)
              }),
            isActive: $shouldMoveToProfileSetup
          ) { EmptyView() }
        }
      }.frame(maxWidth: .infinity, alignment: .leading)
      .onTapGesture {
        hideKeyboard()
      }
    }.padding(.horizontal)
    .navigationTitle("Stretch")
    .alert(isPresented: $noConsentAlertShowing) {
      Alert(
        title: Text("I need your consent"),
        message: Text("Before you can use Stretch, we need to have your consent.")
      )
    }
  }
}
