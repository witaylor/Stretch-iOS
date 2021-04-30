//
//  StretchRepView.swift
//  StretchApp
//
// Created by Will Taylor on 16/01/2021.
//

import AVKit
import SwiftUI
import Combine

struct StretchRepView: View {
  @State var stretchRoutine: StretchRoutine
  var currentStretchIndex: Int = 0 // default to the first stretch
  // function to close the stretch routine sheet
  var onRoutineComplete: (StretchRoutine) -> ()
  var shouldShowStreakExtended: Bool = true
  
  @State private var setsPerformed: Int = 0
  @State private var isAlertShowing = false
  @State private var isShowingNextStretch = false
  @State private var currentRepSkipped = false
  @State private var stretchInProgress = false
  @State private var isShowingStreakExtended = false
  
  // timer state
  @State private var secondsElapsed: Int = 0
  @State private var timerProgress: CGFloat = 0
  
  @State private var timer: Timer?
  @State private var audioPlayer: AVAudioPlayer!
  
  private func currentPerformableStretch() -> PerformableStretch {
    stretchRoutine.stretches[currentStretchIndex]
  }
  
  private func currentStretch() -> Stretch {
    currentPerformableStretch().stretch
  }
  
  private func startStretchTimer() {
    // only if stretch is timed
    if currentStretch().type == .timed {
      let targetHoldSeconds = currentPerformableStretch().reps
      
      timer = Timer.scheduledTimer(
        withTimeInterval: 1.0,
        repeats: true
      ) { timer in
        secondsElapsed += 1
        timerProgress = CGFloat(secondsElapsed) / (CGFloat(targetHoldSeconds))
        
        if secondsElapsed == targetHoldSeconds {
          // stop timer
          timer.invalidate()
          
          stretchInProgress = false
          
          // play sound and show complete alert
          self.audioPlayer.play()
          currentRepSkipped = false
          isAlertShowing = true
        }
      }
      // ensure timer is set before adding to runloop
      guard let timer = timer else { return }
      
      // add to common runloop, allows interaction while running
      RunLoop.current.add(timer, forMode: .common)
    }
  }
  
  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        // stretch name and info
        VStack(alignment: .leading) {
          Text(currentStretch().name)
            .font(.title)
          
          // rep/time info
          HStack {
            Text(currentStretch().type == .timed
                  ? "\(currentPerformableStretch().sets) sets, hold for \(currentPerformableStretch().reps)s"
                  : "\(currentPerformableStretch().sets) sets of \(currentPerformableStretch().reps) reps"
            )
            .fontWeight(.semibold)
            .foregroundColor(Color.gray)
            
            Spacer()
            
            Text("\(setsPerformed + 1)/\(currentPerformableStretch().sets)")
              .fontWeight(.semibold)
          }.foregroundColor(Color.gray)
          
          StretchGuideView(stretch: currentStretch())
        }
      }
      
      VStack {
        // only show timer for timed stretches
        if currentStretch().type == .timed {
          TimerBarView(
            value: $timerProgress,
            endValue: currentPerformableStretch().reps
          )
          .frame(maxHeight: 50)
        }
      }
      
      // buttons
      VStack(spacing: 10) {
        // start stretching button
        PrimaryButton(
          label: currentStretch().type == .repBased
            ? "Complete this set"
            : stretchInProgress ? "Stop stretching" : "Start stretching",
          backgroundColor: currentStretch().type == .timed && stretchInProgress
            ? Color.accentRed
            : Color.accentGreen,
          action: {
            HapticManager.lightTap()
            
            if (currentStretch().type == .timed) && stretchInProgress {
              // stop timer
              if let timer = timer {
                timer.invalidate()
                stretchInProgress = false
              }
            } else if (currentStretch().type == .timed) {
              stretchInProgress = true
              startStretchTimer()
            } else {
              // show complete alert
              currentRepSkipped = false
              isAlertShowing = true
            }
          }
        )
        
        // skip set button
        PrimaryButton(
          label: "Skip this set",
          foregroundColor: .black,
          backgroundColor: .lightGrey,
          fontWeight: .light,
          action: {
            HapticManager.lightTap()
            
            // stop timer
            if (currentStretch().type == .timed) && stretchInProgress {
              // stop timer
              if let timer = timer {
                timer.invalidate()
                stretchInProgress = false
              }
            }
            
            currentRepSkipped = true
            isAlertShowing = true
          }
        )
      }
      .padding(.bottom, 5)
      
      // hidden navigation link for going to next stretch
      // only build if there is a next stretch
      if currentStretchIndex + 1 < stretchRoutine.totalStretches {
        NavigationLink(
          destination: StretchRepView(
            stretchRoutine: stretchRoutine,
            currentStretchIndex: currentStretchIndex + 1,
            onRoutineComplete: onRoutineComplete
          ),
          isActive: $isShowingNextStretch
        ) {
          EmptyView()
        }
      }
      
      // link to streak extended view
      // only build on the last stretch
      if currentStretchIndex + 1 >= stretchRoutine.totalStretches {
        NavigationLink(
          destination: StreakExtendedView(
            onDismiss: {
              onRoutineComplete(stretchRoutine)
            }
          ),
          isActive: $isShowingStreakExtended
        ) {
          EmptyView()
        }
      }
    }.onAppear {
      let sound = Bundle.main.path(forResource: "BoxingBell", ofType: "wav")
      self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
    }
    .padding(.horizontal)
    .navigationTitle("Stretch")
    .navigationBarBackButtonHidden(true)
    .alert(isPresented: $isAlertShowing) {
      Alert(title: Text(currentRepSkipped ? "Rep skipped" : "Stretch complete"),
            message: Text(currentRepSkipped ? "You skipped a rep. Let's do the next one!" : "Great work!"),
            dismissButton: Alert.Button.default(
              Text("Dismiss"),
              action: {
                stretchInProgress = false
                
                if setsPerformed + 1 < currentPerformableStretch().sets {
                  setsPerformed += 1
                  
                  // reset timer metrics
                  secondsElapsed = 0
                  timerProgress = 0
                } else {
                  if currentStretchIndex + 1 < stretchRoutine.totalStretches {
                    // mark current stretch as complete
                    if !currentRepSkipped {
                      self.stretchRoutine.stretches[currentStretchIndex].complete()
                    }
                    
                    // and go to next stretch if there is one
                    self.isShowingNextStretch = true
                  } else {
                    // mark current stretch as complete
                    if !currentRepSkipped {
                      self.stretchRoutine.stretches[currentStretchIndex].complete()
                    }
                    
                    // set routine as complete if at least one stretch is done
                    stretchRoutine.isComplete = stretchRoutine.stretches.filter {
                      $0.completed
                    }.count > 0
                    
                    if stretchRoutine.isComplete && shouldShowStreakExtended {
                      // show streak extended
                      isShowingStreakExtended = true
                    } else {
                      // call onComplete
                      onRoutineComplete(stretchRoutine)
                    }
                  }
                }
              }
            )
      )
    }
  }
}
