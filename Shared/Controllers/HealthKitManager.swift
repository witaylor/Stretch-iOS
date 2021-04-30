//
//  HealthKitManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 04/03/2021.
//

import Foundation
import HealthKit

class HealthKitManager {
  public static let shared = HealthKitManager()
  private var healthKitStore: HKHealthStore? = nil
  
  private init() {
    if HKHealthStore.isHealthDataAvailable() {
      healthKitStore = HKHealthStore()
    }
  }
  
  func requestHealthKitAccess() {
    guard let healthStore = self.healthKitStore else { return }
    let stepType = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    healthStore.requestAuthorization(toShare: nil, read: stepType) { (success, error) in
      if !success {
        print("🔴 ERROR AUTHORISING HEALTHKIT!")
      } else {
        print("✅ HEALTHKIT AUTHORISED!")
      }
    }
  }
  
  func getStepCountForToday(completion: @escaping (Double) -> ()) {
    guard let healthStore = self.healthKitStore else { return }
    
    if !HKHealthStore.isHealthDataAvailable() {
      return
    }
    
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    let now = Date()
    let startOfDay = Calendar.current.startOfDay(for: now)
    let predicate = HKQuery.predicateForSamples(
      withStart: startOfDay,
      end: now,
      options: .strictStartDate
    )
    
    let query = HKStatisticsQuery(
      quantityType: stepsQuantityType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum
    ) { _, result, _ in
      guard let result = result, let sum = result.sumQuantity() else {
        completion(0.0)
        return
      }
      completion(sum.doubleValue(for: HKUnit.count()))
    }
    
    healthStore.execute(query)
  }
  
  func getHistoricalStepData(
    since startDate: Date,
    to endDate: Date = Date(),
    completion: @escaping ([StepData]?) -> ()
  ) {
    guard let healthStore = self.healthKitStore else {
      completion(nil)
      return
    }
    if !HKHealthStore.isHealthDataAvailable() {
      completion(nil)
      return
    }
    var stepData: [StepData] = []
    
    let predicate = HKQuery.predicateForSamples(
      withStart: startDate,
      end: endDate,
      options: [.strictStartDate, .strictEndDate]
    )
    // interval is 1 day
    var interval = DateComponents()
    interval.day = 1
    
    // start from midnight
    let calendar = Calendar.current
    let anchorDate = calendar.date(
      bySettingHour: 0,
      minute: 0,
      second: 0,
      of: Date()
    )
    
    let query = HKStatisticsCollectionQuery(
      quantityType: HKSampleType.quantityType(forIdentifier: .stepCount)!,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum,
      anchorDate: anchorDate!,
      intervalComponents: interval
    )
    
    query.initialResultsHandler = { query, results, error in
      guard let results = results else {
        return
      }
      results.enumerateStatistics(
        from: startDate,
        to: endDate,
        with: { (result, stop) in
          let totalStepForADay = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
          stepData.append(StepData(
            date: result.startDate, stepCount: totalStepForADay
          ))
        }
      )
      
      print("Completing with step data: \(stepData)")
      completion(stepData)
    }
    
    healthStore.execute(query)
  }
}
