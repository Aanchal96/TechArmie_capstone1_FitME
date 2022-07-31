

import Foundation

//MARK:- Api Keys

//=======================
enum ApiKey {
    
    static let name = "name"
    
    //before after
    static let subscription = "subscription"
    static let mainTagId = "mainTagId"
    static let before = "before"
    static let after = "after"
    static let shareUrl = "shareUrl"
    //notification
    static let subscriptionStatus = "subscriptionStatus"
    static let waterSettings = "waterSettings"
    static let stepSettings = "stepSettings"
    static let workoutSettings = "workoutSettings"
    //weight progress
    static let filterType = "filterType"
    static let graph = "graph"
    static let weightHistory = "weightHistory"
    //profile
    static let currentLanguage = "currentLanguage"
    static let currentUnitMeasure = "currentUnitMeasure"
    static let initialUserWeight = "initialUserWeight"
    static let oldPassword = "oldPassword"
    static let newPassword = "newPassword"
    
    //exercise library
    static let exeData = "exeData"
    
    //challenge
    static let workoutDetail = "workoutDetail"
    static let workoutBurnCalories = "workoutBurnCalories"
    static let dayNo = "dayNo"
    static let workoutStatus = "workoutStatus"
    static let currentDay = "currentDay"
    static let challengeId = "challengeId"
    static let completedWorkoutCount = "completedWorkoutCount"
    static let challengeName = "challengeName"
    static let userChallengeId = "userChallengeId"
    static let currentChallenge = "currentChallenge"
    static let challengeList = "challengeList"
    
    static let isAlreadyLogin = "isAlreadyLogin"
    static let isLeft = "isLeft"
    static let intakeEndDate = "intakeEndDate"
    static let interval = "interval"
    static let startTime = "startTime"
    static let endTime = "endTime"
    static let todaysIntakes = "todaysIntakes"
    static let activityIntakes = "activityIntakes"
    static let intakeTime = "intakeTime"
    static let dateOfIntake = "dateOfIntake"
    static let drinkSize = "drinkSize"
    static let todaysIntake = "todaysIntake"
    static let dailyGoal = "dailyGoal"
    static let waterIntakesToday = "waterIntakesToday"
    static let workout = "workout"
    static let stepsSettings = "stepsSettings"
    static let tagData = "tagData"
    
    static let startRange = "startRange"
    static let endRange = "endRange"
    static let tagsId = "tagsId"
    static let ingredCategoryId = "ingredCategoryId"
    
    static let startDate = "startDate"
    static let endDate = "endDate"

    static let currDate = "currDate"
    static let varietyFrequency = "varietyFrequency"
    static let audioUrlEn = "audioUrlEn"
    static let audioUrlAr = "audioUrlAr"
    static let activityAnswer = "activityAnswer"
    static let activityAnsId = "activityAnsId"
    static let daysLeftInWorkout = "daysLeftInWorkout"
    static let isSameDayCompleted = "isSameDayCompleted"
    static let warmupExe = "warmupExe"
    static let noOfDays = "noOfDays"
    static let initialDate = "initialDate"
    static let lateDays = "lateDays"
    static let idToSend = "id"
    static let userId = "userId"
    static let workoutId = "workoutId"
    static let exerciseId = "exerciseId"
    static let alternateExeId = "alternateExeId"
    static let initialTrainingDaysPerWeek = "initialTrainingDaysPerWeek"
    static let initialWorkoutDays = "initialWorkoutDays"
    static let trainingStartDate = "trainingStartDate"
    static let trainingDaysPerWeek = "trainingDaysPerWeek"
    static let workoutDays = "workoutDays"
    static let userFeedback = "userFeedback"
    static let workoutDate = "workoutDate"
    static let totalBurnCalories = "totalBurnCalories"
    static let completedWorkouts = "completedWorkouts"
    static let programDuration = "programDuration"
    static let priorityLevel = "priorityLevel"
    static let cooldownExe = "cooldownExe"
    static let authtoken = "authtoken"
    static let emailVerified = "emailVerified"
    static let lastUpdatedWeight = "lastUpdatedWeight"
    
    static var userGoal : String {return "userGoal"}
    
    static let timezone = "timezone"
    static let social = "social"
    static let gmailToken = "gmailToken"
    static let gmailLogin = "gmailLogin"

    static var userWeight : String {return "userWeight"}
    static var userHeight : String {return "userHeight"}
    static var age : String {return "age"}
    static var goalToJoin : String {return "goalToJoin"}
    static var userActivity : String {return "userActivity"}
    static var resetToken : String {return "resetToken"}
    static var status: String { return "status" }
    static var code: String { return "statusCode" }
    static var result: String { return "result" }
    static var message: String { return "message" }
    static var Authorization: String { return "authtoken" }
    static var user_id: String { return "user_id" }
    static var first_name: String { return "first_name" }
    static var last_name: String { return "last_name" }
    static var email: String { return "email" }
    static var password: String { return "password" }
    static var profileImage : String {return "profileImage"}
    static var confirmPassword: String { return "confirmPassword" }
    static var gender: String { return "gender" }
    static var dob: String { return "dob" }

    static var device_id: String { return "device_id" }
    static var device_token: String { return "device_token" }
    static var platform: String { return "platform" }
    
    static var token: String { return "token" }
    static var refreshToken: String { return "refresh_token" }
    static var resetSuccess: String { return "resetSuccess" }
    static var oldpassword: String { return "oldpassword" }
    
    static var deviceData : String {return "deviceData"}
    static var deviceType : String {return "deviceType"}
    static var deviceToken : String {return "deviceToken"}
    static var deviceId : String {return "deviceId"}
    static var deviceName : String {return "deviceName"}
    static var loginType : String {return "loginType"}
    static var loginToken : String {return "loginToken"}
    static var regType : String {return "regType"}
    static var authToken : String {return "authtoken"}
    
    //new data
    static var height : String{return "height"}
    static var weight : String{return "weight"}
    static var weightGoal : String{return "weightGoal"}
    static var unitSetting : String{return "unitSetting"}
    static var fitnessLevel : String{return "fitnessLevel"}
    static var fitnessQues : String {return "fitnessQues"}
    static var fitnessQuesId : String {return "fitnessQuesId"}
    static var points : String {return "points"}
    static var totalNo : String {return "totalNo"}
    
    //all programs
    static var id : String{return "_id"}
    static var nextPage : String{return "nextPage"}
    static var totalRecords : String{return "totalRecords"}
    static var levelName : String{return "levelName"}
    static var createdAt : String{return "createdAt"}
    static var updatedAt : String{return "updatedAt"}
    static var programName : String{return "programName"}
    static var noOfWorkouts : String{return "noOfWorkouts"}
    static var noOfUsers : String{return "noOfUsers"}
    static var levelId : String{return "levelId"}
    static var level : String{return "level"}
    static var duration : String{return "duration"}
    static var description : String{return "description"}
    static var programData : String{return "progData"}
    static var mediaUrl : String{return "mediaUrl"}
    static var mediaUrlThumb : String{return "mediaUrlThumb"}
    static var mediaType : String{return "mediaType"}
    static var media : String{return "media"}
    static var data : String{return "data"}
    static var page : String{return "page"}
    static var type : String{return "type"}
    static var totalExercises : String{return "totalExercises"}
    
    // Training Initial
    static var queryDate : String{return "queryDate"}
    static var progressStatus : String{return "progressStatus"}
    static var workoutData : String{return "workoutData"}
    static var workoutName : String{return "workoutName"}
    static var workoutDuration : String{return "totalWorkoutDuration"}
    static var workoutExercies : String{return "noOfExercise"}
    static var workoutCalories : String{return "totalBurnCalories"}
    static var programId : String{return "programId"}
    static var isRestDay : String{return "isRestDay"}
    
    //EXERCISE LIST WORKOUT DETAIL VC
    static var exerciseName : String{return "exerciseName"}
    static var exeDuration : String {return "exeDuration"}
    static var exerciseType : String {return "exerciseType"}
    static var restDuration : String {return "restDuration"}
    static var workoutType : String {return "workoutType"}
    static var noOfRounds : String {return "noOfRounds"}
    static var workoutExe : String {return "workoutExe"}
    static var uniqObjectId : String{return "uniqObjectId"}
    static var mediaUrlThumb1 : String{return "mediaUrlThumb1"}
    static var mediaUrlThumb2 : String{return "mediaUrlThumb2"}
    
    //Alternative exercise list
    static var alternateExeData : String{return "alternateExeData"}
    
    //EXERCISE DETAIL
    static var burnCalories : String{return "burnCalories"}
    static var activeStatus : String{return "activeStatus"}
    static var categoryId : String{return "categoryId"}
    static var muscleId : String{return "targetMuscleId"}
    static var instructions : String{return "instructions"}
    static var tips : String{return "tips"}
    static var muscleName : String{return "muscleName"}
    static var categoryName : String{return "categoryName"}
    
    static var joinedId : String {return  "joinedId"}
    static var isWorkoutCompleted : String {return "isWorkoutCompleted"}
    static var dayName : String {return "dayName"}
    static var isActive : String {return "isActive"}
    
    static var workoutSubtitle : String {return "workoutSubtitle"}

    static var weekNo : String {return "weekNo"}
    static var pendingWorkout : String{return "pendingWorkouts"}
    static var isLocked : String{return "isLocked"}
    
    static var libraryData = "libraryData"
    static var categoryData = "categoryData"
    static var ongoingWeek = "ongoingWeek"
    static var weeklyProgressStatus = "weeklyProgressStatus"
    static var timeConsumption = "timeConsumption"
    
    static var burntCalories = "burntCalories"
    
    static var startDayNo = "startDayNo"
    static var endDayNo = "endDayNo"
    static var _id = "_id"
    
    static var totalSteps = "totalSteps"
    static var consumptionDateString = "consumptionDateString"
    static var dairyProgStartDateString = "dairyProgStartDateString"
    static var stepsToday = "stepsToday"
    static var dailyProgStartDate = "dailyProgStartDate"
    static var stepsBurntCalories = "stepsBurntCalories"
    static var totalWaterIntake = "totalWaterIntake"
}
