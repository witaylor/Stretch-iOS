//
//  DataManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 24/02/2021.
//

import Foundation

class DataManager {
  // singleton
  private init() {
    loadStretchData()
    loadUserData()
    loadAwardList()
    appState.todaysRoutine = getTodaysStretchRoutine()
  }
  public static let shared = DataManager()
  
  // TODO: maybe move this to a constants file or something
  private final let USER_INFO_FILENAME = "UserInfo.json"
  
  private var appState: AppState = AppState()
  private var curStretchDay: StretchDay!
  
  // load stretch data from file
  private func loadStretchData() {
    do {
      // load data from file
      if let bundlePath = Bundle.main.path(forResource: "StretchData", ofType: "json"),
         let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        // decode and store
        let stretchList = try JSONDecoder().decode([Stretch].self, from: jsonData)
        appState.stretchList = stretchList
        
        // fatalError if load failed, somethings gone very wrong
        guard let strList = appState.stretchList else {
          fatalError()
        }
        
        // print some load metrics
        print("""
              -----------------------------
              🚀 LOADED STRETCH DATA FROM FILE
              * found \(strList.count) stretches
              """)
      }
    } catch {
      print("[ERROR loading stretch data]\n\(error)")
      fatalError()
    }
  }
  
  // load award list from file
  private func loadAwardList() {
    do {
      // load data from file
      if let bundlePath = Bundle.main.path(forResource: "Awards", ofType: "json"),
         let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        // decode and store
        let awardList = try JSONDecoder().decode([Award].self, from: jsonData)
        appState.awardList = awardList
        
        // fatalError if load failed, somethings gone very wrong
        guard let awdList = appState.awardList else {
          fatalError()
        }
        
        // print some load metrics
        print("""
              -----------------------------
              🚀 LOADED AWARD DATA FROM FILE
              * found \(awdList.count) awards
              """)
      }
    } catch {
      print("[ERROR loading award data]\n\(error)")
      fatalError()
    }
  }
  
  // load user data from file
  private func loadUserData() {
    do {
      // load from file
      guard let userFileUrl = buildUrlForFile(filename: USER_INFO_FILENAME) else {
        fatalError()
      }
      print("Reading user data from:\n\(userFileUrl.absoluteString)")
      
      if FileManager.default.fileExists(atPath: userFileUrl.path) {
        print("USER INFO FILE EXISTS")
      } else {
        createDefaultUserData(url: userFileUrl)
      }
      
      let fileData = try Data(contentsOf: userFileUrl)
      let userData = try JSONDecoder().decode(UserProfile.self, from: fileData)
      appState.userInfo = userData
      
      // use stored day for today
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
      }
      
      // print some load metrics
      print("""
            -----------------------------
            🚀 LOADED USER DATA FROM FILE
            * USER: \(appState.userInfo?.name ?? "nil")
            * STEP: \(appState.userInfo?.stepGoal ?? -1)
            * DAYS: \(appState.userInfo?.userStretchHistory.count ?? -1)
            * AWAR: \(appState.awardList?.count ?? -1)
            """)
    } catch {
      print("[ERROR loading user data]\n\(error)")
      fatalError()
    }
  }
  
  func getAppState() -> AppState { self.appState }
  
  private func createDefaultUserData(url userFileUrl: URL) {
    print("USER INFO FILE NOT FOUND // CREATING DEFAULTS")
    
    let defaultUserJSON = """
                            {
                              "name": "User #1",
                              "stepGoal": 10000,
                              "stretchGoalSeconds": 600,
                              "userStretchHistory": [],
                              "awardsEarned": []
                            }
                          """
    let jsonData = Data(defaultUserJSON.utf8)
    do {
      try jsonData.write(to: userFileUrl, options: .atomic)
      
      print("Successfully written data to file!")
      print(userFileUrl.absoluteString)
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
    let numOfStretches = 3
    let allStretches = appState.stretchList!
    var stretches: [PerformableStretch] = []
    var usedIndexes: [Int] = [] // for avoiding duplicates
    
    for _ in 0..<numOfStretches {
      var randIndex = Int.random(in: 0..<allStretches.count)
      
      // keep generating new indexes if its in the used list
      while usedIndexes.contains(randIndex) {
        randIndex = Int.random(in: 0..<allStretches.count)
      }
      
      let stretch = allStretches[randIndex]
      // todo - dynamic build of sets + reps
      // currently, 10 reps or 10 seconds hold for all stretches
      let perfStretch = PerformableStretch(stretch: stretch, sets: 3, reps: 10, completed: false)
      
      usedIndexes.append(randIndex)
      stretches.append(perfStretch)
    }
    
    return StretchRoutine(
      totalStretches: numOfStretches,
      estimatedDurationMinutes: 15, // todo - work this out
      stretches: stretches
    )
  }
  
  func getTodaysStretchRoutine() -> StretchRoutine {
    curStretchDay.stretchRoutine
  }
  
  private func getCurrentStretchDay() -> StretchDay {
    curStretchDay
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
    
    print("Finding month -- \(curDate.get(.month))/\(curDate.get(.year))")
    history.forEach { month in
      print("""
              current: \(curDate.get(.month))/\(curDate.get(.year))
              month  : \(month.month)/\(month.year)
              equal  : \(month.month == curDate.get(.month) && month.year == curDate.get(.year))


              """)
    }
    
    if let index = history.firstIndex(where: {
      $0.month == curDate.get(.month) &&
        $0.year == curDate.get(.year)
    }) {
      print("""
              Found entry for month at i:\(index)-- \(history[index].month)/\(history[index].year)
              """)
      history[index].days.append(curStretchDay)
    } else {
      // assume month doesnt exist so create it
      print("CREATING NEW MONTH ENTRY")
      history.append(StretchMonth(
        month: curDate.get(.month),
        year: curDate.get(.year),
        totalDaysStretched: -1,
        avgDiscomfort: 0,
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
        
        print("Successfully written to file!")
        print(pathWithFileName.absoluteString)
        print(appState.userInfo?.userStretchHistory ?? "Nothing Found")
      } catch {
        // handle error
        print("[ERROR] \(error)")
      }
    }
  }
}
