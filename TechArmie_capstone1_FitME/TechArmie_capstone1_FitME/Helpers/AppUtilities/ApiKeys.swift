//
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation

//TODO: - Remove extras
//MARK: - Api Keys

//=======================
enum ApiKey {
    
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
    //recipe lib
    static let mainTagTitle = "mainTagTitle"
    //weight progress
    static let filterType = "filterType"
    static let graph = "graph"
    static let weightHistory = "weightHistory"
    //recipe - library
    static let taggedMeals = "taggedMeals"
    static let mealData = "mealData"
    //profile
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
    //
    static let mealSettings = "mealSettings"
    static let lastUpdatedWeight = "lastUpdatedWeight"
    static let consumptionDate = "consumptionDate"
    static let foodName = "foodName"
    static let totalWeightofMeal = "totalWeightofMeal"
    static let totalServing = "totalServing"
    static let action = "action"
    static let weightKg = "weightKg"
    static let weightUpdationDate = "weightUpdationDate"
    
    static let isAlreadyLogin = "isAlreadyLogin"
    static let isLeft = "isLeft"
    static let waterIntakeSettings = "waterIntakeSettings"
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
    static let mealInitial = "mealInitial"
    static let stepsSettings = "stepsSettings"
    static let tagData = "tagData"
    static let ingredCategory = "ingredCategory"

    static let startRange = "startRange"
    static let endRange = "endRange"
    static let tagsId = "tagsId"
    static let ingredCategoryId = "ingredCategoryId"
    
    static let mealList = "mealList"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let unitTypeWeight = "unitTypeWeight"
    static let unitTypeAmount = "unitTypeAmount"
    static let catId = "catId"
    static let alterNateIngredName = "alterNateIngredName"
    static let mealProgStartDate = "mealProgStartDate"
    static let initialMealId = "initialMealId"
    static let breakfast = "breakfast"
    static let lunch = "lunch"
    static let dinner = "dinner"
    static let snacks = "snacks"
    static let currDate = "currDate"
    static let foodNotLiked = "foodNotLiked"
    static let varietyFrequency = "varietyFrequency"
    static let foodNotLikedList = "foodNotLikedList"
    static let planDate = "planDate"
    static let audioUrlEn = "audioUrlEn"
    static let audioUrlAr = "audioUrlAr"
    static let activityAnswer = "activityAnswer"
    static let activityAnsId = "activityAnsId"
    static let isSwapped = "isSwapped"
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
    static let isTrainingDaysSet = "isTrainingDaysSet"
    static let authtoken = "authtoken"
    static let emailVerified = "emailVerified"
    static let notifStatus = "notifStatus"
    
    static let timezone = "timezone"
    static let social = "social"
    static let reminder = "reminder"
    static let reminderTime = "reminderTime"
    static let gmailToken = "gmailToken"
    static let gmailLogin = "gmailLogin"
    static let facebookLogin = "facebookLogin"
    static let facebookToken = "facebookToken"
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
    static var name: String { return "name" }
    static var first_name: String { return "first_name" }
    static var last_name: String { return "last_name" }
    static var email: String { return "email" }
    static var password: String { return "password" }
    static var profileImage : String {return "profileImage"}
    static var confirmPassword: String { return "confirmPassword" }
    static var gender: String { return "gender" }
    static var phone: String { return "phone" }
    static var dob: String { return "dob" }
    static var address: String { return "address" }
    static var user_lat: String { return "user_lat" }
    static var user_long: String { return "user_long" }
    static var country_id: String { return "country_id" }
    static var state_id: String { return "state_id" }
    static var city_id: String { return "city_id" }
    static var device_id: String { return "device_id" }
    static var device_token: String { return "device_token" }
    static var platform: String { return "platform" }
    
    static var token: String { return "token" }
    static var refreshToken: String { return "refresh_token" }
    static var resetSuccess: String { return "resetSuccess" }
    static var oldpassword: String { return "oldpassword" }

    static var timeZone : String {return "timezone"}
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
    static var categoryIngredName : String {return "categoryIngredName"}
    static var ingredList : String {return "ingredList"}

    //MARK:- MEAL
    static var mainCardArr : String {return "mainCardArr"}
    static var planCategory : String {return "planCategory"}
    static var planCategoryNo : String {return "planCategoryNo"}
    static var progData : String {return "progData"}
    static var noOfPerDayMeals : String {return "noOfPerDayMeals"}
    static var isMainCard : String {return "isMainCard"}
    static var planName : String {return "planName"}
    static var shortDescription : String {return "shortDescription"}
    static var dinnerMeals : String {return "dinnerMeals"}
    static var calories : String {return "calories"}
    static var lunchMeals : String {return "lunchMeals"}
    static var carbs : String {return "carbs"}
    static var planCategoryId : String {return "planCategoryId"}
    static var fats : String {return "fats"}

    static var breakfastMeals : String {return "breakfastMeals"}
    static var backgroundColor : String {return "backgroundColor"}
    static var protein : String {return "protein"}
    static var mealPlanId : String {return "mealPlanId"}
    static var planId : String {return "planId"}
    static var isPlanStarted : String {return "isPlanStarted"}
    static var lastIntakeMealUpdate : String {return "lastIntakeMealUpdate"}
    static var initialIntakeMealDate : String {return "initialIntakeMealDate"}
    static var mealProgramId : String {return "mealProgramId"}
    
    static var mealName : String {return "mealName"}
    static var totalProtein : String {return "totalProtein"}
    static var totalFats : String {return "totalFats"}
    static var totalCarbs : String {return "totalCarbs"}
    static var prepnTime : String {return "prepnTime"}
    static var totalCalories : String {return "totalCalories"}
    static var dietType : String {return "dietType"}
    static var categoryNo : String {return "categoryNo"}
    static var mealCategory : String {return "mealCategory"}
    static var mealPercentage : String {return "mealPercentage"}
    static var intakeStatus : String {return "intakeStatus"}
    static var carbsGm : String {return "carbsGm"}
    static var proteinGm : String {return "proteinGm"}
    static var fatGm : String {return "fatGm"}
    static var carbsConsumedGm : String {return "carbsConsumedGm"}
    static var proteinConsumedGm : String {return "proteinConsumedGm"}
    static var fatConsumedGm : String {return "fatConsumedGm"}
    static var meals : String {return "meals"}
    static var macroNutrientData : String {return "macroNutrientData"}
    static var targetCalories : String {return "targetCalories"}
    static var consumedCalories : String {return "consumedCalories"}
    static var consumptionPercentage : String {return "consumptionPercentage"}
    static var tagName : String {return "tagName"}
    static var ingredName : String {return "ingredName"}
    static var quantityWeight : String {return "quantityWeight"}
    static var ingredData : String {return "ingredData"}
    static var quantity : String {return "quantity"}
    static var unitType : String {return "unitType"}
    static var quantityAmount : String {return "quantityAmount"}
    static var mealPlan : String {return "mealPlan"}
    
    static var dateOfMeal : String{return "dateOfMeal"}
    static var mealId : String{return "mealId"}
    static var alternateMealId : String {return "alternateMealId"}
    static var mealTime : String {return "mealTime"}
    static var mealReminder : String {return "mealReminder"}
    
    static var search : String {return "search"}
    static var userGoal : String {return "userGoal"}
    static var pace : String {return "pace"}
    static var paceSettings : String {return "paceSettings"}
    static var paceData : String {return "paceData"}
    
    static var weekNo : String {return "weekNo"}
    static var pendingWorkout : String{return "pendingWorkouts"}
    static var isLocked : String{return "isLocked"}
    
    static var libraryData = "libraryData"
    static var categoryData = "categoryData"
    static var ongoingWeek = "ongoingWeek"
    static var weeklyProgressStatus = "weeklyProgressStatus"
    static var whatToDo = "whatToDo"
    static var timeConsumption = "timeConsumption"
    
    static var burntCalories = "burntCalories"
    static var dietTagId = "dietTagId"
    
    static var startDayNo = "startDayNo"
    static var endDayNo = "endDayNo"
    static var _id = "_id"

    static var totalSteps = "totalSteps"
    static var consumptionDateString = "consumptionDateString"
    static var dairyProgStartDateString = "dairyProgStartDateString"
    static var stepsToday = "stepsToday"
    static var dailyProgStartDate = "dailyProgStartDate"
    static var stepsBurntCalories = "stepsBurntCalories"
    static var dairyDailyLogs = "dairyDailyLogs"
    static var totalWaterIntake = "totalWaterIntake"
    static var caloryRange = "caloryRange"
    static var mainMacroNutrients = "mainMacroNutrients"
    static var mealDistribution = "mealDistribution"
    static var carbsPercentage = "carbsPercentage"
    static var proteinPercentage = "proteinPercentage"
    static var fatsPercentage = "fatsPercentage"
    static var consumedFats = "consumedFats"
    static var consumedProtein = "consumedProtein"
    static var consumedCarbs = "consumedCarbs"
    
    static var consumedBreakfast = "consumedBreakfast"
    static var dinnerPercentage = "dinnerPercentage"
    static var consumedLunch = "consumedLunch"
    static var consumedSnacks = "consumedSnacks"
    static var lunchPercentage = "lunchPercentage"
    static var breakfastPercentage = "breakfastPercentage"
    static var snacksPercentage = "snacksPercentage"
    static var consumedDinner = "consumedDinner"
    static var dairyId = "dairyId"
    
    static var uniqId = "uniqId"

    
}
