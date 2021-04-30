//
//  MailManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 07/03/2021.
//

import Foundation
import MessageUI
import SwiftUI

class MailManager: NSObject, MFMailComposeViewControllerDelegate {
  private override init() { super.init() }
  public static let shared = MailManager()
  
  private var appState = DataManager.shared.getAppState()
  
  func canSendMail() -> Bool {
    MFMailComposeViewController.canSendMail()
  }
  
  /// Compose an email containing the necessary data for the study
  func sendStudyData() -> Alert? {
    guard let userInfo = appState.userInfo else {
      return Alert(
        title: Text("Something went wrong"),
        message: Text("Make sure you have Apple's Mail app installed on your iPhone.")
      )
    }
    
    let dayComp = DateComponents(day: -8)
    let oneWeekAgo = Calendar.current.date(byAdding: dayComp, to: Date())!
    
    var studyData = StudyData(
      userEmail: userInfo.emailAddress,
      history: userInfo.userStretchHistory,
      steps: nil,
      stepGoal: userInfo.stepGoal
    )
    HealthKitManager.shared.getHistoricalStepData(
      since: oneWeekAgo,
      completion: { (sd: [StepData]?) in
        studyData.steps = sd
      }
    )
    
    while studyData.steps == nil {
      // idle wait
      // yes I know this is bad
      print("waiting for step data")
    }
    
    do {
      let encoder = JSONEncoder()
      let studyJson = try encoder.encode(studyData)
      
      return sendStudyDataEmail(data: studyJson)
    } catch {
      return Alert(
        title: Text("Something went wrong"),
        message: Text("Please try again.")
      )
    }
  }
  
  func sendStudyDataEmail(data: Data) -> Alert? {
    let recipientEmail = "wat23@bath.ac.uk"
    let subject = "Stretch Study Data"
    let emailBody = """
          <h2>🔬 Your study data</h2>
          <p>
            The file attached to this email contains all the data necessary for
            the study. As outlined before, it <strong>contains no personal data,
            or any other data that can be linked back to you</strong>. The data
            contained in the file, and how it will be used, is outlined below.
          </p>
          <div style="margin: 1em 0">
            <h3>📁 What's in the file?</h3>
            <ul>
              <li>
                A identifier, unique to you, that will only be used to
                differentiate the stretch data for each person. The identifier
                is completely random and cannot be linked to you.
              </li>
              <li>
                Your stretch history. This is a list of all the stretches you
                have completed in the Stretch app, along with all discomfort
                ratings you have submitted and your step count for a given day.
                This data will be used to evaluate the effectiveness of Stretch.
                The key things we'll be looking out for is the relationship
                between your movements (stretching and step count) and
                discomfort you felt for each day, and how these levels varied
                over the course of the study.
              </li>
            </ul>
          </div>
          <div style="margin: 1em 0">
            <h3>🤔 Won't you know who I am from this email?</h3>
            <p>
              Yes, and no. While I'll know who sent this email, the data file
              will be downloaded and then the email will be destroyed. This means
              that when it comes to analysing the data, it will be completely
              anonymous. The only time your name/email address will be used is
              to verify that I have received your study data.
            </p>
          </div>

          <p>
            🙏 <strong>Thank you</strong> for being an essential part of my
            dissertation study.
          </p>
        """
    
    let mail = MFMailComposeViewController()
    mail.mailComposeDelegate = self
    mail.setToRecipients([recipientEmail])
    mail.setSubject(subject)
    mail.setMessageBody(emailBody, isHTML: true)
    
    mail.addAttachmentData(
      data,
      mimeType: "application/json",
      fileName: "StudyData.json"
    )
    
    if MFMailComposeViewController.canSendMail() {
      if let rootVc = getRootViewController() {
        rootVc.present(mail, animated: true)
        return nil
      } else {
        return Alert(
          title: Text("Something went wrong"),
          message: Text("Make sure you have Apple's Mail app installed on your iPhone.")
        )
      }
    }
    return Alert(
      title: Text("Cannot send mail"),
      message: Text("Due to some limitations on how iOS handles files, you need to have Apple's Mail app installed.")
    )
  }
  
  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    controller.dismiss(animated: true)
  }
  
  func getRootViewController() -> UIViewController? {
    UIApplication.shared.windows.first?.rootViewController
  }
}
