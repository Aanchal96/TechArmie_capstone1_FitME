//
//  ExerciseLibraryModel.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import SwiftyJSON

struct ExerciseLibraryModel{
    var categoryName : String
    var media : [ProgramMediaModel]
    var exeData : [ExerciseDetailModel]
    
    init(_ json : JSON = JSON()){
        categoryName = json[ApiKey.categoryName].stringValue
        media = json[ApiKey.media].arrayValue.map({ProgramMediaModel.init($0)})
        exeData = json[ApiKey.exeData].arrayValue.map({ExerciseDetailModel.init($0)})
    }
}

struct ExerciseDetailModel {
    var media: [ProgramMediaModel]
    var exerciseName: String
    var nameCategory: String
    
    init(_ json: JSON = JSON()) {
        
        let mediaArray = json[ApiKey.media].arrayValue
        media = mediaArray.map( { ProgramMediaModel($0) } )
        exerciseName = json[ApiKey.exerciseName].stringValue
        nameCategory = json[ApiKey.categoryName].stringValue
    }
}

struct ProgramMediaModel {
    let id: String
    let mediaUrl: String
    let mediaUrlThumb1: String
    
    init(_ json: JSON = JSON()) {
        id = json[ApiKey.id].stringValue
        mediaUrl = json[ApiKey.mediaUrl].stringValue.trimTrailingWhitespace()
        mediaUrlThumb1 = json[ApiKey.mediaUrlThumb1].stringValue.trimTrailingWhitespace()        
    }
}
