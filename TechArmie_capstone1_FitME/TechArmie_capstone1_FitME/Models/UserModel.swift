//
//  UserModel.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-30.
//

import Foundation
import FirebaseAuth
import SwiftyJSON

// MARK: - Model class to store the user information...
// MARK: ==============================================
class AuthUser {
    
    static var main = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile)) {
        didSet {
            main.saveToUserDefaults()
        }
    }
    
    let id: String
    var name: String
    var email: String
    let createdAt: String
    let token, authToken: String
    var isAlreadyLogin : Bool = false
    
    var profileImage : String
    
    var goalToJoin: Int
    var gender: Gender
    var age : Int
    var userWeight : UserWeight
    var userHeight : UserHeight
    var usergoal : UserWeight
    var currentUnitMeasure : String // 2 imperial
    var priorityLevel : Int // Activity Level in Step 3
    
    var initialUserWeight : UserWeight
    var lastUpdatedWeight : UserWeight

    init (_ json: JSON = JSON()) {
        
        id = json[ApiKey.id].stringValue
        name = json[ApiKey.name].stringValue
        email = json[ApiKey.email].stringValue
        createdAt = json[ApiKey.createdAt].stringValue
        token = json[ApiKey.token].stringValue
        authToken = json[ApiKey.authtoken].stringValue
        
        profileImage = json[ApiKey.profileImage].stringValue
        
        goalToJoin = json[ApiKey.goalToJoin].intValue
        gender =   json[ApiKey.gender].stringValue == Gender.male.rawValue ? .male : .female
        age = json[ApiKey.age].intValue
        let weight = json[ApiKey.userWeight].dictionaryValue
        userWeight = UserWeight(JSON(weight))
        let height = json[ApiKey.userHeight].dictionaryValue
        userHeight = UserHeight(JSON(height))
        let goal = json[ApiKey.userGoal].dictionaryValue
        usergoal = UserWeight(JSON(goal))
        currentUnitMeasure = json[ApiKey.currentUnitMeasure].stringValue
        priorityLevel = json[ApiKey.priorityLevel].intValue
        
        let initialWeight = json[ApiKey.initialUserWeight].dictionaryValue
        initialUserWeight = UserWeight(JSON(initialWeight))
        let lastWeight = json[ApiKey.lastUpdatedWeight].dictionaryValue
        lastUpdatedWeight = UserWeight(JSON(lastWeight))

    }

    func saveToUserDefaults() {
        
        let dict: JSONDictionary = [ApiKey.email:email,
                                    ApiKey.token:token,
                                    ApiKey.name:name,
                                    ApiKey.profileImage:profileImage,
                                    ApiKey.id:id,
                                    ApiKey.authtoken:authToken,
                                    ApiKey.goalToJoin:goalToJoin,
                                    ApiKey.gender:gender.rawValue,
                                    ApiKey.userWeight:userWeight.getDict(),ApiKey.lastUpdatedWeight:lastUpdatedWeight.getDict(),
                                    ApiKey.initialUserWeight: initialUserWeight.getDict(),
                                    ApiKey.userHeight:userHeight.getDict(), ApiKey.userGoal : usergoal.getDict()  ,
                                    ApiKey.priorityLevel : priorityLevel,
                                    ApiKey.currentUnitMeasure : currentUnitMeasure,
                                    ApiKey.age : age
        ]
        
        AppUserDefaults.save(value: dict, forKey: .fullUserProfile)
    }
    
}

struct UserHeight {
    
    let unitSetting : String
    let height : Double
    
    init() {
        self.init(JSON())
    }
    
    init(_ json: JSON = JSON()) {
        
        unitSetting = json[ApiKey.unitSetting].stringValue
        height = json[ApiKey.height].doubleValue
    }
    func getDict() -> JSONDictionary{
        return [ApiKey.unitSetting : unitSetting , ApiKey.height : height ]
    }
}

struct UserWeight {
    
    var unitSetting : String
    var weight : Double
    
    init() {
        self.init(JSON())
    }
    
    init(_ json: JSON = JSON()) {
        
        unitSetting = json[ApiKey.unitSetting].stringValue
        weight = json[ApiKey.weight].doubleValue
    }
    func getDict() -> JSONDictionary{
        return [ApiKey.unitSetting : unitSetting , ApiKey.weight : weight ]
    }
}

struct ProfileModel{
    var goal: Goal = .loseWeight
    var age = 0
    var height = ""
    var weight = ""
    var weightGoal = ""
    var gender : Gender = .male
    var level = ProgramLevel.beginner
    var activity = ""
    var dob = ""
    var heightDict : JSONDictionary?
    var weightDict : JSONDictionary?
    var weightGoalDict : JSONDictionary?
    var pace = 0
    var targetCalories = 0
}
