//
//  ExerciseLibraryModel.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import SwiftyJSON

//TODO: Remove extras -

struct ExerciseDetailModel {
    var media: [ProgramMediaModel]
    var exerciseName: String
    var instructions: [String]
    var categoryName: [String]
    var id: String
    var nameCategory: String
    
    init(_ json: JSON = JSON()) {
        
        let mediaArray = json[ApiKey.media].arrayValue
        media = mediaArray.map( { ProgramMediaModel($0) } )
        exerciseName = json[ApiKey.exerciseName].stringValue
        instructions = json[ApiKey.instructions].arrayValue.map({$0.stringValue})
        categoryName = json[ApiKey.categoryName].arrayValue.map({$0.stringValue})
        id = json[ApiKey.id].stringValue
        nameCategory = json[ApiKey.categoryName].stringValue
    }
}

struct ExerciseLibraryModel{
    var categoryName : String
    var id : String
    var media : [ProgramMediaModel]
    var exeData : [ExerciseDetailModel]
    
    init(_ json : JSON = JSON()){
        categoryName = json[ApiKey.categoryName].stringValue
        id = json[ApiKey.id].stringValue
        media = json[ApiKey.media].arrayValue.map({ProgramMediaModel.init($0)})
        exeData = json[ApiKey.exeData].arrayValue.map({ExerciseDetailModel.init($0)})
    }
}


struct ProgramMediaModel {
    let id: String
    let mediaUrl: String
    let mediaUrlThumb: String
    let audioUrlAr: String
    let audioUrlEn: String
    let mediaType: Int //(mediaType:1 img,2-video,3-gif)
    let mediaUrlThumb1: String
    let mediaUrlThumb2: String
    let initialDate: String
    let noOfDays: Int
    let isSameDayCompleted: Int
    
    init(_ json: JSON = JSON()) {
        initialDate = json[ApiKey.initialDate].stringValue
        noOfDays = json[ApiKey.noOfDays].intValue
        isSameDayCompleted = json[ApiKey.isSameDayCompleted].intValue
        
        id = json[ApiKey.id].stringValue
        mediaUrl = json[ApiKey.mediaUrl].stringValue.trimTrailingWhitespace()
        mediaUrlThumb = json[ApiKey.mediaUrlThumb].stringValue.trimTrailingWhitespace()
        mediaType = json[ApiKey.mediaType].intValue
        mediaUrlThumb1 = json[ApiKey.mediaUrlThumb1].stringValue.trimTrailingWhitespace()
        mediaUrlThumb2 = json[ApiKey.mediaUrlThumb2].stringValue.trimTrailingWhitespace()
        
        audioUrlAr = json[ApiKey.audioUrlAr].stringValue.trimTrailingWhitespace()
        audioUrlEn = json[ApiKey.audioUrlEn].stringValue.trimTrailingWhitespace()
        
    }
}
