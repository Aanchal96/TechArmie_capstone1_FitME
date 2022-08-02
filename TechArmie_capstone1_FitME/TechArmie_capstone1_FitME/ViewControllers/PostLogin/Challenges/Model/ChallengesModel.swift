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
    var description: String
    var levelName: String
    
    init(_ json: JSON = JSON()) {
        challengeList = json[ApiKey.programData].arrayValue.map({Challenge($0)})
        description = json[ApiKey.description].stringValue
        levelName = json[ApiKey.levelName].stringValue
    }
}


struct Challenge {
    
    var id: String
    var challengeName: String
    var description: String
    var media: [ProgramMediaModel]    
    var result: ExerciseResult
    
    init(_ json : JSON = JSON()) {
        id = json[ApiKey.id].stringValue
        challengeName = json[ApiKey.challengeName].stringValue
        description = json[ApiKey.description].stringValue
        media = json[ApiKey.media].arrayValue.map({ProgramMediaModel($0)})
        result = ExerciseResult(json)
    }
}

struct WorkoutModel {
    
    let name: String
    let id: String
    let duration: Int //In seconds
    let calories: Int //In cal
    let description: String
    let medias: [ProgramMediaModel]
    let workoutSubtitle: String
    var json: JSON
  
    
    init(_ json: JSON = JSON()) {
        self.json = json
        workoutSubtitle = json[ApiKey.workoutSubtitle].stringValue
        name = json[ApiKey.workoutName].stringValue
        id = json[ApiKey.id].stringValue
        duration = json[ApiKey.workoutDuration].intValue / 60 //In minutes
        calories = json[ApiKey.workoutCalories].intValue  //In KCal
        description = json[ApiKey.description].stringValue
        
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
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
    let noOfRounds : Int
    let medias : [ProgramMediaModel]
    let calories : Int
    var flag = 0
    
    init(_ json: JSON = JSON()) {
        exerciseName = json[ApiKey.exerciseName].stringValue
        id = json[ApiKey.id].stringValue
        exeDuration = json[ApiKey.exeDuration].intValue
        exerciseType = json[ApiKey.exerciseType].intValue
        restDuration = json[ApiKey.restDuration].intValue
        noOfRounds = json[ApiKey.noOfRounds].intValue
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
        calories = json[ApiKey.burnCalories].intValue
    }
}


struct ProgramModel {
    
    var pendingWorkouts : [WorkoutModel]
    let name : String
    let medias : [ProgramMediaModel]
    let levelName : String

    init(_ json: JSON = JSON()) {

        name = json[ApiKey.programName].stringValue
        levelName = json[ApiKey.levelName].stringValue
        let mediaArray = json[ApiKey.media].arrayValue
        medias = mediaArray.map({ProgramMediaModel($0)})
        let pendingWorkoutArray = json[ApiKey.pendingWorkout].arrayValue
        pendingWorkouts = pendingWorkoutArray.map({WorkoutModel($0)})
    }
}
