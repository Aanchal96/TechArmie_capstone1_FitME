//
//  ChallengesModel.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import Foundation
import SwiftyJSON

struct ChallengeModel {
    
    var challengeList: [Challenge]
    var id: String
    var description: String
    var levelName: String
    var totalExercises: String
    
    init(_ json: JSON = JSON()) {
        challengeList = json[ApiKey.programData].arrayValue.map({Challenge($0)})
        description = json[ApiKey.description].stringValue
        levelName = json[ApiKey.levelName].stringValue
        id = json[ApiKey.id].stringValue
        totalExercises = json[ApiKey.totalExercises].stringValue
    }
}


struct Challenge {
    
    var id: String
    var noOfWorkouts: Int
    var completedWorkoutCount: Int
    var challengeName: String
    var description: String
    var media: [ProgramMediaModel]
    var userChallengeId: String
    var progressStatus: Float
    var duration: Int
    var currentDay: Int
    var workoutData: [WorkoutModel]
    var isJoined: Bool = false
    
    var result: ExerciseResult
    
    
    init(_ json : JSON = JSON()) {
        id = json[ApiKey.id].stringValue
        noOfWorkouts = json[ApiKey.noOfWorkouts].intValue
        completedWorkoutCount = json[ApiKey.completedWorkoutCount].intValue
        challengeName = json[ApiKey.challengeName].stringValue
        description = json[ApiKey.description].stringValue
        userChallengeId = json[ApiKey.userChallengeId].stringValue
        progressStatus = Float(json[ApiKey.progressStatus].intValue)
        media = json[ApiKey.media].arrayValue.map({ProgramMediaModel($0)})
        workoutData = json[ApiKey.workoutDetail].arrayValue.map({WorkoutModel($0)})
        duration = json[ApiKey.duration].intValue
        currentDay = json[ApiKey.currentDay].intValue
        isJoined = userChallengeId != ""
        result = ExerciseResult(json)

    }
}

struct WorkoutModel {
    
    let name: String
    let id: String
    let duration: Int //In seconds
    let calories: Int //In cal
    let noOfExecises: Int
    let programId: String
    let createdAt: String
    let description: String
    let medias: [ProgramMediaModel]
    let workoutSubtitle: String

    var dayNo: Int
    var workoutStatus: Int
    var workoutBurnCalories: Int
    var json: JSON
  
    
    init(_ json: JSON = JSON()) {
        self.json = json
        workoutSubtitle = json[ApiKey.workoutSubtitle].stringValue
        name = json[ApiKey.workoutName].stringValue
        id = json[ApiKey.id].stringValue
        duration = json[ApiKey.workoutDuration].intValue / 60 //In minutes
        calories = json[ApiKey.workoutCalories].intValue  //In KCal
        noOfExecises = json[ApiKey.workoutExercies].intValue
        programId = json[ApiKey.programId].stringValue
        createdAt = json[ApiKey.createdAt].stringValue
        description = json[ApiKey.description].stringValue
        
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
        
        workoutStatus = json[ApiKey.workoutStatus].intValue
        dayNo = json[ApiKey.dayNo].intValue
        workoutBurnCalories = json[ApiKey.workoutBurnCalories].intValue
    }
}


struct ExerciseResult{
    let exerciseModel : [[ExerciseModel]]
    let warmUpModel : [ExerciseModel]
    let coolDownModel : [ExerciseModel]
    var media : [ProgramMediaModel]
    var workoutData: WorkoutModel
    
    init(_ json: JSON = JSON()) {
        let arr = json["exerciseData"]["result"]["workoutExe"].arrayValue
        let arrWarmup = json["warmupData"]["result"]["warmupExe"].arrayValue
        let arrCooldown = json["warmupData"]["result"]["cooldownExe"].arrayValue
        workoutData = WorkoutModel(json["exerciseData"]["result"])
        warmUpModel = arrWarmup.map({ExerciseModel($0)})
        coolDownModel = arrCooldown.map({ExerciseModel($0)})
        let mediaArray = json[ApiKey.media].arrayValue
        media = mediaArray.map({ProgramMediaModel($0)})
        exerciseModel = arr.map({
            let arrTemp = $0.arrayValue
            return arrTemp.map({
                ExerciseModel($0)
            })
        })
    }
}


struct ExerciseModel {
    
    let exerciseName : String
    let id : String
    let exerciseType : Int
    let exeDuration : Int
    var restDuration : Int
    let workoutType : Int
    let noOfRounds : Int
    let uniqObjectId : String
    var isAlreadySwapped : Bool = false
    let medias : [ProgramMediaModel]
    
    let calories : Int
    let activeStatus : Int
    let categoryId : String
    let muscles : [String]
    let muscleIds : [String]
    let instructions : [String]
    let tips : [String]
    let categoryNames : [String]
    var flag = 0
    var level : Int
    
    init(_ json: JSON = JSON()) {
        isAlreadySwapped = json[ApiKey.isSwapped].intValue == 1
        exerciseName = json[ApiKey.exerciseName].stringValue
        id = json[ApiKey.id].stringValue
        exeDuration = json[ApiKey.exeDuration].intValue
        exerciseType = json[ApiKey.exerciseType].intValue
        restDuration = json[ApiKey.restDuration].intValue
        workoutType = json[ApiKey.workoutType].intValue
        noOfRounds = json[ApiKey.noOfRounds].intValue
        uniqObjectId = json[ApiKey.uniqObjectId].stringValue
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
        
        calories = json[ApiKey.burnCalories].intValue
        activeStatus = json[ApiKey.activeStatus].intValue
        categoryId = json[ApiKey.categoryId].stringValue
        muscles = json[ApiKey.muscleName].arrayValue.map({$0.stringValue})
        muscleIds = json[ApiKey.muscleId].arrayValue.map({$0.stringValue})
        instructions = json[ApiKey.instructions].arrayValue.map({$0.stringValue})
        tips = json[ApiKey.tips].arrayValue.map({$0.stringValue})
        categoryNames = json[ApiKey.categoryName].arrayValue.map({$0.stringValue})
        level = json[ApiKey.level].intValue
    }
}


struct ProgramModel {
    
    let description : String
    let level : Int
    let pendingWorkouts : [WorkoutModel]
    let createdAt : String
    let duration : Int //In Weeks
    let name : String
    let medias : [ProgramMediaModel]
    let id : String
    let joinedId : String
    let levelName : String
    let completedWorkouts : [WorkoutModel]
    let levelId : String
    let programId : String
    let noOfWorkouts : Int
    let progressStatus : Float
    var ongoingWeek : Int
    var weeklyProgressStatus : Float
    var result : [String]
    var whatToDo : [String]
    var priorityLevel : Int = 1

    init(_ json: JSON = JSON()) {

        name = json[ApiKey.programName].stringValue
        id = json[ApiKey.id].stringValue
        levelId = json[ApiKey.levelId].stringValue
        noOfWorkouts = json[ApiKey.noOfWorkouts].intValue
        level = json[ApiKey.level].intValue
        duration = json[ApiKey.duration].intValue
        description = json[ApiKey.description].stringValue
        joinedId = json[ApiKey.joinedId].stringValue
        levelName = json[ApiKey.levelName].stringValue
        programId = json[ApiKey.programId].stringValue
        createdAt = json[ApiKey.createdAt].stringValue
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
        let pendingWorkoutArray = json[ApiKey.pendingWorkout].arrayValue
        pendingWorkouts = pendingWorkoutArray.map({WorkoutModel($0)})
        let completedWorkoutArray = json[ApiKey.completedWorkouts].arrayValue
        completedWorkouts = completedWorkoutArray.map({WorkoutModel($0)})
        progressStatus = json[ApiKey.progressStatus].floatValue
        ongoingWeek = json[ApiKey.ongoingWeek].intValue
        weeklyProgressStatus =  json[ApiKey.weeklyProgressStatus].floatValue
        result = json[ApiKey.result].arrayValue.map{$0.stringValue}
        whatToDo = json[ApiKey.whatToDo].arrayValue.map({$0.stringValue})
        priorityLevel = json[ApiKey.priorityLevel].intValue

    }
}
