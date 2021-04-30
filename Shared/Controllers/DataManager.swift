//
//  DataManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

class DataManager {
  private init() {
    loadStretchData()
    loadUserData()
    loadAwardList()
    appState.todaysRoutine = getTodaysStretchRoutine()
  }
  public static let shared = DataManager()
  private final let USER_INFO_FILENAME = "UserInfo.json"
  
  private var appState: AppState = AppState()
  private var curStretchDay: StretchDay!
  
  // timer to keep track of the total timer a user has stretched
  // this was not used in the submission data
  private var totalStretchTimer: Timer? = nil
  private var totalStretchSeconds: Int = 0
  private var shouldStopTimer = false
  
  private let lengthOfStudyInDays = 8
  
  // load stretch data from file
  private func loadStretchData() {
    do {
      if let bundlePath = Bundle.main.path(forResource: "StretchData", ofType: "json"),
         let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        let stretchList = try JSONDecoder().decode([Stretch].self, from: jsonData)
        appState.stretchList = stretchList
        
        // fatalError if load failed, somethings gone very wrong
        guard appState.stretchList != nil else {
          fatalError()
        }
      }
    } catch {
      fatalError()
    }
  }
  
  // load award list from file
  private func loadAwardList() {
    do {
      if let bundlePath = Bundle.main.path(forResource: "AwardList", ofType: "json"),
         let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        var awardList = try JSONDecoder().decode([Award].self, from: jsonData)
        
        // update the awards with the completed list in user data
        if let userAwards = appState.userInfo?.awardsEarned {
          for (index, _) in awardList.enumerated() {
            if userAwards.contains(where: { (id: UUID) -> Bool in
              id == awardList[index].id
            }) {
              awardList[index].achieved = true
            }
          }
        }
        appState.awardList = awardList
        
        // fatalError if load failed, somethings gone very wrong
        guard appState.awardList != nil else {
          fatalError()
        }
      } else {
        fatalError()
      }
    } catch {
      fatalError()
    }
  }
  
  // load user data from file
  private func loadUserData() {
    do {
      guard let userFileUrl = buildUrlForFile(filename: USER_INFO_FILENAME) else {
        fatalError()
      }
      print("Reading user data from:\n\(userFileUrl.absoluteString)")
      
      
      // Check for user data, create file if none exists
      if !FileManager.default.fileExists(atPath: userFileUrl.path) {
        createDefaultUserData(url: userFileUrl)
      }
      
      let fileData = try Data(contentsOf: userFileUrl)
      let userData = try JSONDecoder().decode(UserProfile.self, from: fileData)
      appState.userInfo = userData
      
      let curDate = Date()
      if let today = appState
          .userInfo?
          .userStretchHistory
          .first(where: {
            $0.month == curDate.get(.month) &&
              $0.year == curDate.get(.year)
          })?
          .days.first(where: { day in
            day.date.get(.day) == curDate.get(.day)
          }) {
        curStretchDay = today
      } else {
        // else setup new day data
        curStretchDay = StretchDay(
          date: Date(),
          stretchRoutine: buildTodaysStretchRoutine()
        )
        saveRoutineToHistory(curStretchDay.stretchRoutine)
      }
    } catch {
      fatalError()
    }
  }
  
  func getAppState() -> AppState { self.appState }
  
  private func createDefaultUserData(url userFileUrl: URL) {
    // date for the start of the study
    let currentDate = Date()
    do {
      let defaultUserJSON = """
                            {
                              "name": "",
                              "emailAddress": "",
                              "userId": "\(UUID().uuidString)",
                              "hasGivenConsent": false,
                              "stepGoal": 0,
                              "stretchGoalSeconds": 0,
                              "userStretchHistory": [],
                              "awardsEarned": [
                                "615908d7-0c50-4b61-b629-5be699d2e1d5"
                              ],
                              "remindersEnabled": false,
                              "stretchReminderTime": null,
                              "studyDates": {
                                "start": \(currentDate.timeIntervalSince1970),
                                "end": \(getStudyEndDate(start: currentDate).timeIntervalSince1970)
                              }
                            }
                          """
      let jsonData = Data(defaultUserJSON.utf8)
      try jsonData.write(to: userFileUrl, options: .atomic)
    } catch {
      // handle error
      print("[ERROR] \(error)")
    }
  }
  
  private func buildUrlForFile(filename: String) -> URL? {
    FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    ).first?.appendingPathComponent(filename)
  }
  
  private func buildTodaysStretchRoutine() -> StretchRoutine {
    // mins to stretch for each day
    // this is a minimum, actual duration will be higher
    let targetStretchTime = 10
    
    let allStretches = appState.stretchList!
    var stretches: [PerformableStretch] = []
    var usedIndexes: [Int] = [] // for avoiding duplicate stretches
    
    var estimatedRoutineSeconds = 0
    
    while estimatedRoutineSeconds < (targetStretchTime * 60) {
      var randIndex = Int.random(in: 0..<allStretches.count)
      
      // keep generating new indexes if its in the used list
      while usedIndexes.contains(randIndex) {
        randIndex = Int.random(in: 0..<allStretches.count)
      }
      
      let stretch = allStretches[randIndex]
      let perfStretch = PerformableStretch(
        stretch: stretch,
        sets: 3,
        reps: stretch.type == .timed ? 20 : 10,
        completed: false
      )
      usedIndexes.append(randIndex)
      stretches.append(perfStretch)
      
      // update estimated duration
      if stretch.type == .repBased {
        // assume 2 seconds per rep
        estimatedRoutineSeconds += (perfStretch.reps * (perfStretch.reps * 2))
      } else { // else timed
        estimatedRoutineSeconds += (perfStretch.sets * perfStretch.reps)
      }
      // update with rest times - assume 30 seconds rest
      estimatedRoutineSeconds += 30
    }
    
    return StretchRoutine(
      totalStretches: stretches.count,
      estimatedDurationMinutes: estimatedRoutineSeconds / 60,
      stretches: stretches
    )
  }
  
  func getTodaysStretchRoutine() -> StretchRoutine {
    curStretchDay.stretchRoutine
  }
  
  func getStretchHistory() -> StretchHistory {
    guard let monthHistory = appState.userInfo?.userStretchHistory else {
      return StretchHistory(months: [])
    }
    return StretchHistory(months: monthHistory)
  }
  
  func saveRoutineToHistory(_ routine: StretchRoutine) {
    guard var history = appState.userInfo?.userStretchHistory else {
      return
    }
    
    // update stretchDay in memory
    let curDate = Date()
    // and update the routine
    curStretchDay.stretchRoutine = routine
    
    if let index = history.firstIndex(where: {
      $0.month == curDate.get(.month) &&
        $0.year == curDate.get(.year)
    }) {
      // update day if it exists
      if let dayInd = history[index].days.firstIndex(where: { (sd: StretchDay) -> Bool in
        sd.date.isSameDate(as: curDate)
      }) {
        history[index].days[dayInd] = curStretchDay
      } else {
        // otherwise add a new one
        history[index].days.append(curStretchDay)
      }
    } else {
      // assume month doesnt exist so create it
      history.append(StretchMonth(
        month: curDate.get(.month),
        year: curDate.get(.year),
        days: [curStretchDay]
      ))
    }
    appState.userInfo?.userStretchHistory = history
    
    // and update the JSON file
    if let jsonData = try? JSONEncoder().encode(appState.userInfo),
       let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
      do {
        let pathWithFileName = documentDirectory.appendingPathComponent(USER_INFO_FILENAME)
        try jsonData.write(to: pathWithFileName, options: .atomic)
      } catch {
        // handle error
        print("[ERROR] \(error)")
      }
    }
  }
  
  func saveDiscomfortRating(of newRating: Int) {
    guard var history = appState.userInfo?.userStretchHistory else {
      return
    }
    
    // update stretchDay in memory
    let curDate = Date()
    // and update the routine
    curStretchDay.discomfortRating = newRating
    
    if let index = history.firstIndex(where: {
      $0.month == curDate.get(.month) &&
        $0.year == curDate.get(.year)
    }) {
      // update day if it exists
      if let dayInd = history[index].days.firstIndex(where: { (sd: StretchDay) -> Bool in
        sd.date.isSameDate(as: curDate)
      }) {
        history[index].days[dayInd] = curStretchDay
      } else {
        // otherwise add a new one
        history[index].days.append(curStretchDay)
      }
    } else {
      // assume month doesnt exist so create it
      history.append(StretchMonth(
        month: curDate.get(.month),
        year: curDate.get(.year),
        days: [curStretchDay]
      ))
    }
    appState.userInfo?.userStretchHistory = history
    
    // and update the JSON file
    if let jsonData = try? JSONEncoder().encode(appState.userInfo),
       let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
      do {
        let pathWithFileName = documentDirectory.appendingPathComponent(USER_INFO_FILENAME)
        try jsonData.write(to: pathWithFileName, options: .atomic)
      } catch {
        // handle error
        print("[ERROR] \(error)")
      }
    }
  }
  
  func updateUserInfo(
    name: String? = nil,
    email: String? = nil,
    stepGoal: Int? = nil,
    givenConsent: Bool? = nil,
    dataSubmissionDate: Date? = nil
  ) {
    if let n = name {
      appState.userInfo?.name = n
    }
    if let em = email {
      appState.userInfo?.emailAddress = em
    }
    if let sg = stepGoal {
      appState.userInfo?.stepGoal = sg
    }
    if let gc = givenConsent {
      appState.userInfo?.hasGivenConsent = gc
    }
    if let sd = dataSubmissionDate {
      appState.userInfo?.lastSharedStudyData = sd
    }
    
    saveUserInfo()
  }
  
  private func saveUserInfo() {
    guard let userFileUrl = buildUrlForFile(filename: USER_INFO_FILENAME) else {
      fatalError()
    }
    
    let jsonEncoder = JSONEncoder()
    let jsonData = try! jsonEncoder.encode(appState.userInfo)
    
    do {
      try jsonData.write(to: userFileUrl, options: .atomic)
    } catch {
      // handle error
      print("[ERROR] \(error)")
    }
  }
  
  func hasUserGivenConsent() -> Bool {
    appState.userInfo?.hasGivenConsent ?? false
  }
  
  func getDiscomfortRating() -> Int {
    curStretchDay.discomfortRating
  }
  
  func saveAdditionalStretches(_ routine: StretchRoutine) {
    guard var history = appState.userInfo?.userStretchHistory else {
      return
    }
    
    // update stretchDay in memory
    let curDate = Date()
    // and update the routine
    if curStretchDay.additionalStretches == nil {
      curStretchDay.additionalStretches = []
    }
    routine.stretches.forEach {
      curStretchDay.additionalStretches?.append($0)
    }
    
    if let index = history.firstIndex(where: {
      $0.month == curDate.get(.month) &&
        $0.year == curDate.get(.year)
    }) {
      // update day if it exists
      if let dayInd = history[index].days.firstIndex(where: { (sd: StretchDay) -> Bool in
        sd.date.isSameDate(as: curDate)
      }) {
        history[index].days[dayInd] = curStretchDay
      } else {
        // otherwise add a new one
        history[index].days.append(curStretchDay)
      }
    } else {
      // assume month doesnt exist so create it
      history.append(StretchMonth(
        month: curDate.get(.month),
        year: curDate.get(.year),
        days: [curStretchDay]
      ))
    }
    appState.userInfo?.userStretchHistory = history
    
    // and update the JSON file
    if let jsonData = try? JSONEncoder().encode(appState.userInfo),
       let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
      do {
        let pathWithFileName = documentDirectory.appendingPathComponent(USER_INFO_FILENAME)
        try jsonData.write(to: pathWithFileName, options: .atomic)
      } catch {
        // handle error
        print("[ERROR] \(error)")
      }
    }
  }
  
  private func getStudyEndDate(start: Date) -> Date {
    Calendar.current.date(
      byAdding: .day,
      value: lengthOfStudyInDays + 1,
      to: start
    )!
  }
  
  func startTotalStretchTimer() {
    if let oldTimer = totalStretchTimer {
      oldTimer.invalidate()
    }
    shouldStopTimer = false
    
    totalStretchTimer = Timer.scheduledTimer(
      withTimeInterval: 1.0,
      repeats: true
    ) { [self] timer in
      totalStretchSeconds += 1
      
      if shouldStopTimer {
        timer.invalidate()
        
        print("-- ending stretch timer :: \(totalStretchSeconds) seconds.")
        
        // update file
        guard var history = appState.userInfo?.userStretchHistory else {
          return
        }
        
        // update stretchDay in memory
        let curDate = Date()
        
        if let index = history.firstIndex(where: {
          $0.month == curDate.get(.month) &&
            $0.year == curDate.get(.year)
        }) {
          // update day if it exists
          if let dayInd = history[index].days.firstIndex(where: { (sd: StretchDay) -> Bool in
            sd.date.isSameDate(as: curDate)
          }) {
            history[index].days[dayInd] = curStretchDay
          } else {
            // otherwise add a new one
            history[index].days.append(curStretchDay)
          }
        } else {
          // assume month doesnt exist so create it
          history.append(StretchMonth(
            month: curDate.get(.month),
            year: curDate.get(.year),
            days: [curStretchDay]
          ))
        }
        appState.userInfo?.userStretchHistory = history
        
        // and update the JSON file
        if let jsonData = try? JSONEncoder().encode(appState.userInfo),
           let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first {
          do {
            let pathWithFileName = documentDirectory.appendingPathComponent(USER_INFO_FILENAME)
            try jsonData.write(to: pathWithFileName, options: .atomic)
          } catch {
            // handle error
            print("[ERROR] \(error)")
          }
        }
        
        totalStretchTimer = nil
      }
    }
    // ensure timer is set before adding to runloop
    guard let timer = totalStretchTimer else { return }
    // add to common runloop, allows interaction while running
    RunLoop.current.add(timer, forMode: .common)
  }
  
  func endTotalStretchTimer() {
    // invalidate timer
    shouldStopTimer = true
  }
  
  func updateStudyEndDate(to date: Date) {
    appState.userInfo?.studyDates.end = date
    saveUserInfo()
  }
}
