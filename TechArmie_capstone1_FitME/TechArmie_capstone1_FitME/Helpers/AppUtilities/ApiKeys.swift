//
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation

//MARK: - Api Keys

//=======================
enum ApiKey {

    static let users = "users"
    static let currentUnitMeasure = "currentUnitMeasure"
    static let initialUserWeight = "initialUserWeight"

    //exercise library
    static let exeData = "exeData"

    //challenge
    static let challengeName = "challengeName"
    static let lastUpdatedWeight = "lastUpdatedWeight"
    static var burnCalories : String{return "burnCalories"}
    static let priorityLevel = "priorityLevel"
    static let authtoken = "authtoken"
    static var userWeight : String {return "userWeight"}
    static var userHeight : String {return "userHeight"}
    static var age : String {return "age"}
    static var goalToJoin : String {return "goalToJoin"}
    static var result: String { return "result" }
    static var name: String { return "name" }
    static var email: String { return "email" }
    static var profileImage : String {return "profileImage"}
    static var gender: String { return "gender" }
    static var token: String { return "token" }
    static var isPremium: String { return "is_premium" }

    //new data
    static var height : String{return "height"}
    static var weight : String{return "weight"}
    static var unitSetting : String{return "unitSetting"}

    //all programs
    static var id : String{return "_id"}
    static var levelName : String{return "levelName"}
    static var createdAt : String{return "createdAt"}
    static var programName : String{return "programName"}
    static var description : String{return "description"}
    static var programData : String{return "progData"}
    static var mediaUrl : String{return "mediaUrl"}
    static var media : String{return "media"}
    static var data : String{return "data"}

    static var workoutName : String{return "workoutName"}
    static var workoutDuration : String{return "totalWorkoutDuration"}
    static var workoutCalories : String{return "totalBurnCalories"}

    //EXERCISE LIST WORKOUT DETAIL VC
    static var exerciseName : String{return "exerciseName"}
    static var exeDuration : String {return "exeDuration"}
    static var exerciseType : String {return "exerciseType"}
    static var restDuration : String {return "restDuration"}
    static var noOfRounds : String {return "noOfRounds"}
    static var mediaUrlThumb1 : String{return "mediaUrlThumb1"}
    static var categoryName : String{return "categoryName"}
    static var workoutSubtitle : String {return "workoutSubtitle"}
    static var userGoal : String {return "userGoal"}
    static var pendingWorkout : String{return "pendingWorkouts"}
    
    static var libraryData = "libraryData"
    static var categoryData = "categoryData"
    
}
