//
//  HealthKitController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//


import UIKit
import HealthKit

class HealthKitController {
    
    static let shared = HealthKitController()
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false , NSError.init(localizedDescription: "HealthKit not available"))
            return
        }
        guard let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let water = HKObjectType.quantityType(forIdentifier: .dietaryWater),
            let protine = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
            let carb = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
            let fat = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
            let fiber = HKObjectType.quantityType(forIdentifier: .dietaryFiber),
            let staFat = HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated),
            let unsatFat = HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated),
            let sugar = HKObjectType.quantityType(forIdentifier: .dietarySugar),
            let enrgy = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else{
                completion(false , NSError.init(localizedDescription: "Unable To Fetch Step"))
                return
        }
        let healthKitTypesToWrite: Set<HKSampleType> = [stepsCount,bodyMass,water,protine,carb,fat,fiber,staFat,unsatFat,sugar,enrgy,HKQuantityType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepsCount]
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                
                                                completion(success, error)
        }
    }
    
    func askPermission(permission : @escaping (Bool) -> ()){
        self.authorizeHealthKit { [weak self] (authorized, error) in
            guard let self = self else {return}
            guard let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)else{
                return
            }
            print( HKHealthStore().authorizationStatus(for: stepsCount))
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    printDebug("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    printDebug(baseMessage)
                }
                return
            }
            permission( HKHealthStore().authorizationStatus(for: stepsCount) == .sharingAuthorized)
        }
        
    }
    
    func getSteps(completion: @escaping (String , Int) -> ()){
        self.authorizeHealthKit { [weak self] (authorized, error) in
            
            guard let self = self else {return}
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    printDebug("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    printDebug(baseMessage)
                }
                return
            }
            let sampleStepCount = HKSampleType.quantityType(forIdentifier: .stepCount)
            let start = Calendar.current.startOfDay(for: Date())
            let end =  Date()
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            guard let sampleStepCounts = sampleStepCount else {return}
            var dailyValue = ""
            var total = 0
            let sampleQuery = HKSampleQuery.init(sampleType: sampleStepCounts, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: { (query, arrResult, error) in
                if error == nil{
                    for samples in (arrResult as? [HKQuantitySample] ?? [])  {
                        printDebug(samples)
                        let dateStr = samples.startDate.toString(dateFormat: "hh:mm a") + " - " + samples.endDate.toString(dateFormat: "hh:mm a")
                        //TODO: Enable - Aanchal
//                        dailyValue += dateStr + " (" + ((samples.quantity.doubleValue(for: HKUnit.count()) ).toIntValue()?.description ?? 0)  + ") steps" + "\n"
                        total += (samples.quantity.doubleValue(for: HKUnit.count())).toIntValue() ?? 0
                    }
                    printDebug(total)
                    completion(dailyValue , total)
                }
            })
            self.healthStore.execute(sampleQuery)
        }
    }
    
    func retrieveStepCountForStat(startDate : Date = Date() , endDate : Date = Date() , dateComponent : DateComponents = DateComponents() , completion: @escaping ([Int]) -> () ) {
        CommonFunctions.showActivityLoader()
        let stepsCounts = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let start = Calendar.current.startOfDay(for: startDate)
        let end =  endDate
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        guard let stepsCount = stepsCounts else {
            CommonFunctions.hideActivityLoader()
            return}
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: start, intervalComponents : dateComponent)
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                CommonFunctions.hideActivityLoader()
                return}
            if let myResults = results{
                var total = 0
                var arrSplitResults : [Int] = [0,0,0,0,0,0,0]
                let start = startDate
                myResults.enumerateStatistics(from: start , to: end) {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print(statistics.startDate.day)
                        print(start.day)
                        let daysBetween = statistics.startDate.daysFrom(start)
                        print(daysBetween)
                        arrSplitResults[daysBetween] = steps.toIntValue() ?? 0
                        printDebug(statistics.startDate.convertToString())
                        printDebug(statistics.endDate.convertToString())
                        printDebug("Steps = \(steps)")
                        total += steps.toIntValue() ?? 0
                        //Perform UI Action IN Main Thread only
                    }
                }
                CommonFunctions.hideActivityLoader()
                completion(arrSplitResults)
                printDebug(total)
            }else{
                CommonFunctions.hideActivityLoader()
            }
        }
        self.healthStore.execute(query)
    }
    
    func retrieveStepDayWise(date : Date = Date() , dateComponent : DateComponents = DateComponents() , completion: @escaping ([(Int,Date,Date)]) -> () ) {
        CommonFunctions.showActivityLoader()
        let stepsCounts = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let start = Calendar.current.startOfDay(for: date)
        let end =  Calendar.current.startOfDay(for: (Calendar.current.date(byAdding: .day, value: 1, to: date)) ?? Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        guard let stepsCount = stepsCounts else {
            CommonFunctions.hideActivityLoader()
            completion([])
            return}
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: start, intervalComponents : dateComponent)
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                CommonFunctions.hideActivityLoader()
                completion([])
                return}
            if let myResults = results{
                var total = 0
                
                var arrSplit = [(Int , Date , Date)]()
                myResults.enumerateStatistics(from: start , to: end) {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        printDebug("Steps = \(steps)")
                        printDebug(statistics.startDate.convertToString())
                        printDebug(statistics.endDate.convertToString())
                        total += steps.toIntValue() ?? 0
                        arrSplit.append((steps.toIntValue() ?? 0 , statistics.startDate , statistics.endDate))
                        //Perform UI Action IN Main Thread only
                    }
                }
                CommonFunctions.hideActivityLoader()
                completion(arrSplit)
            }else{
                completion([])
                CommonFunctions.hideActivityLoader()
            }
        }
        self.healthStore.execute(query)
    }
    
    func saveDataInHealth(totalSteps: Int = 0, weight: Int = 0, totalWaterIntake: Int = 0, consumedProtein: Int = 0, consumedCarbs: Int = 0, consumedFats: Int = 0, consumedFiber: Int = 0, consumedSaturatedFats: Int = 0, consumedUnSaturatedFats: Int = 0, consumedSugar: Int = 0, consumedCalories: Double = 0.0, workoutDuration: Int = 0, burntCalories: Int = 0, date: Date = Date(),id: String = "") {
        
        HealthKitController.shared.askPermission(permission: { (val) in
            printDebug("========== get id \n ======")
            printDebug(id)
            printDebug("========== \n======")
            if val{
                var hkItemArray = [HKQuantitySample]()
                if totalSteps != 0, let stepsCount = self.getHKHealthItem(identifier: .stepCount, value: Double(totalSteps),date: date, uuid: id){
                    hkItemArray.append(stepsCount)
                }
                if weight != 0, let bodyMass = self.getHKHealthItem(identifier: .bodyMass,  unit: HKUnit.gram(), value: Double(weight),date: date, uuid: id){
                    hkItemArray.append(bodyMass)
                }
                if totalWaterIntake != 0, let water = self.getHKHealthItem(identifier: .dietaryWater, unit: HKUnit.liter() , value: Double(totalWaterIntake)/1000.0,date: date, uuid: id){
                    hkItemArray.append(water)
                }
                if consumedProtein != 0, let protine = self.getHKHealthItem(identifier: .dietaryProtein,  unit: HKUnit.gram(),  value: Double(consumedProtein),date: date, uuid: id){
                    hkItemArray.append(protine)
                }
                if consumedCarbs != 0, let carb = self.getHKHealthItem(identifier: .dietaryCarbohydrates,  unit: HKUnit.gram(),  value: Double(consumedCarbs),date: date, uuid: id){
                    hkItemArray.append(carb)
                }
                if consumedFats != 0, let fat = self.getHKHealthItem(identifier: .dietaryFatTotal,  unit: HKUnit.gram(),  value: Double(consumedFats),date: date, uuid: id){
                    hkItemArray.append(fat)
                }
                if consumedFiber != 0, let fat = self.getHKHealthItem(identifier: .dietaryFiber,  unit: HKUnit.gram(),  value: Double(consumedFiber),date: date, uuid: id){
                    hkItemArray.append(fat)
                }
                if consumedSaturatedFats != 0, let staFat = self.getHKHealthItem(identifier: .dietaryFatSaturated,  unit: HKUnit.gram(),  value: Double(consumedSaturatedFats),date: date, uuid: id){
                    hkItemArray.append(staFat)
                }
                if consumedUnSaturatedFats != 0, let unsatFat = self.getHKHealthItem(identifier: .dietaryFatMonounsaturated,  unit: HKUnit.gram(),  value: Double(consumedUnSaturatedFats),date: date, uuid: id){
                    hkItemArray.append(unsatFat)
                }
                if consumedSugar != 0, let sugar = self.getHKHealthItem(identifier: .dietarySugar,  unit: HKUnit.gram(), value: Double(consumedSugar),date: date, uuid: id){
                    hkItemArray.append(sugar)
                }
                if !consumedCalories.isZero, let enrgy = self.getHKHealthItem(identifier: .dietaryEnergyConsumed,  unit: HKUnit.kilocalorie(),  value: consumedCalories,date: date, uuid: id){
                    hkItemArray.append(enrgy)
                }
                
                if hkItemArray.isEmpty{
                    return
                }
                if workoutDuration != 0 , burntCalories != 0 {
                    self.saveWorkout(value: Double(workoutDuration), enrgy: Double(burntCalories), date: Date())
                }
                //3.  Save the same to HealthKit
               
                HKHealthStore().save(hkItemArray) { (success, error) in
                    
                    if let error = error {
                        print("Error Saving BMI Sample: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved BMI Sample")
                    }
                }
            }
        })
    }
 
    
    private func getHKHealthItem(identifier: HKQuantityTypeIdentifier, unit: HKUnit = .count(), value: Double, date: Date ,uuid : String) ->HKQuantitySample?{
        
        //1.  Make sure the body mass type exists
        guard let itemCountType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            printDebug("\(identifier.rawValue) is no longer available in HealthKit")
            return nil
        }
        
        //2.  Use the Count HKUnit to create a body mass quantity
        let itemQuantity = HKQuantity(unit: unit,
                                      doubleValue: value)
        
        let itemCountSample = HKQuantitySample(type: itemCountType,
                                               quantity: itemQuantity,
                                               start: date,
                                               end: date, metadata: [HKMetadataKeyExternalUUID : uuid])
        return itemCountSample
    }
    
   private func saveWorkout(value: Double, enrgy: Double, date: Date){
        
        if value.isZero{
            return
        }
        //1. Setup the Calorie Quantity for total energy burned
        let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(),
                                         doubleValue: enrgy)
        
        //2. Build the workout using data from your Prancercise workout
        let workout = HKWorkout(activityType: .other,
                                start: date,
                                end: date,
                                duration: value,
                                totalEnergyBurned: calorieQuantity,
                                totalDistance: nil,
                                device: HKDevice.local(),
                                metadata: nil)
        
        //3. Save your workout to HealthKit
        let healthStore = HKHealthStore()
        healthStore.save(workout) { (success, error) in
            printDebug(success)
        }
    }
    
    func deleteNutritionData(id :String) {
        printDebug("========== uuid key \n ======")
        printDebug(id)
        printDebug("========== \n======")
        let arr : [HKQuantityTypeIdentifier] = [ .stepCount, .bodyMass, .dietaryWater, .dietaryFiber, .dietaryProtein, .dietarySugar , .dietaryFatMonounsaturated, .dietaryFatSaturated, .dietaryCarbohydrates, .dietaryFatTotal,.dietaryEnergyConsumed]
        CommonFunctions.showActivityLoader()
        arr.forEach { (type) in
            deleteWeightSample(identifier: type, itemTypeKey: id) { (success, error) in
                if type == .dietaryEnergyConsumed {
                    CommonFunctions.hideActivityLoader()
                }
            }
        }
    }
    
    func deleteWeightSample(identifier: HKQuantityTypeIdentifier, itemTypeKey: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Swift.Void) {

        //1
        guard let weightType = HKQuantityType.quantityType(forIdentifier: identifier), let userWeightUUID = UUID(uuidString: itemTypeKey) else {
            // Handle object type construction failure
            return completion(false,nil)
        }

        //2
        let predicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeyExternalUUID, operatorType: .equalTo, value: itemTypeKey)
//        let predicate = HKQuery.predicateForObjects(withMetadataKey: itemTypeKey)
        //3
        self.fetchHealthKitSample(for: weightType, withPredicate: predicate) { (fetchedObject, error) in
            if let error = error {
                // Handle error
                completion(false,error)
            } else {

                guard let unwrappedFetchedObject = fetchedObject else {
                    // Handle when object does not exists
                    return
                }

                //4
                HKHealthStore().delete(unwrappedFetchedObject, withCompletion: { (success, error) in
                    if let error = error {
                        // Handle error
                        completion(false,error)
                    } else {
                        printDebug("========== delete successfully ======")
                        completion(success,nil)

                    }
                })

            }
        }

    }
//
    func fetchHealthKitSample(for healthSampleType: HKSampleType, withPredicate predicate: NSPredicate?, completion: @escaping (HKSample?, Error?) -> Swift.Void) {

            let query = HKSampleQuery(sampleType: healthSampleType, predicate: predicate, limit: 1, sortDescriptors: nil) { (query, samples, error) in

                if let error = error {
                    // Handler error
                    completion(nil,error)
                } else {
                    printDebug(samples)
                    guard let fetchedObject = samples?.first else {

                        // Handler unexisting object
                        completion(nil,nil)
                        return

                    }

                    completion(fetchedObject,nil)

                }

            }

            HKHealthStore().execute(query)
    }
}
