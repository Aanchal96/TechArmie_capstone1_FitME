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
    let name: String
    let email: String
    let createdAt: String
    let token, authToken: String
    var isAlreadyLogin : Bool = false
    
    var goalToJoin: Int
    var gender: Gender
    var age : Int
    var userWeight : UserWeight
    var userHeight : UserHeight
    var usergoal : UserWeight
    var currentUnitMeasure : String // 2 imperial
    var priorityLevel : Int // Activity Level in Step 3
    
    var profileImage : String
    let regType: Int // Registeration type: 1- Email sign up, 2- Social sign up
    
    var initialUserWeight : UserWeight
    var lastUpdatedWeight : UserWeight

    var subscription : SubscriptionModel

    init (_ json: JSON = JSON()) {
        
        id = json[ApiKey.id].stringValue
        name = json[ApiKey.name].stringValue
        email = json[ApiKey.email].stringValue
        createdAt = json[ApiKey.createdAt].stringValue
        token = json[ApiKey.token].stringValue
        authToken = json[ApiKey.authtoken].stringValue
        
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
        
        profileImage = json[ApiKey.profileImage].stringValue
        regType = json[ApiKey.regType].intValue
        
        let initialWeight = json[ApiKey.initialUserWeight].dictionaryValue
        initialUserWeight = UserWeight(JSON(initialWeight))
        let lastWeight = json[ApiKey.lastUpdatedWeight].dictionaryValue
        lastUpdatedWeight = UserWeight(JSON(lastWeight))

        let sub = json[ApiKey.subscription].dictionaryValue
        self.subscription = SubscriptionModel(JSON(sub))
    }
    
    required init(_ googleUser: User?) {
        
        id = googleUser?.uid ?? ""
        name = googleUser?.displayName ?? ""
        email = googleUser?.email ?? ""
    }
    
    func saveToUserDefaults() {
        
        let dict: JSONDictionary = [ApiKey.email:email,
                                    ApiKey.token:token,
                                    ApiKey.name:name,
                                    ApiKey.profileImage:profileImage,
                                    ApiKey.id:id,
                                    ApiKey.authtoken:authToken,
                                    ApiKey.goalToJoin:goalToJoin,
                                    ApiKey.regType:regType,
                                    ApiKey.gender:gender.rawValue,
                                    ApiKey.userWeight:userWeight.getDict(),ApiKey.lastUpdatedWeight:lastUpdatedWeight.getDict(),
                                    ApiKey.userHeight:userHeight.getDict(), ApiKey.userGoal : usergoal.getDict()  ,
                                    ApiKey.priorityLevel : priorityLevel,
                                    ApiKey.currentUnitMeasure : currentUnitMeasure,
                                    ApiKey.age : age,
                                    ApiKey.subscription : subscription.getDict(),
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
    
    let unitSetting : String
    let weight : Double
    
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

struct FitnessModel {
    
    let totalNo : Int
    let id : String
    let points : Int
    let fitnessQuesId : Int
    let fitnessQues : String
    
    init() {
        self.init(JSON())
    }
    
    init(_ json: JSON = JSON()) {
        
        totalNo = json[ApiKey.totalNo].intValue
        id = json[ApiKey.id].stringValue
        points = json[ApiKey.points].intValue
        fitnessQuesId = json[ApiKey.fitnessQuesId].intValue
        fitnessQues = json[ApiKey.fitnessQues].stringValue
    }
    
    func getDict() -> JSONDictionary{
        return [ApiKey.totalNo : totalNo , ApiKey.id : id , ApiKey.points : points , ApiKey.fitnessQuesId : fitnessQuesId ,ApiKey.fitnessQues : fitnessQues ]
    }
}

struct SubscriptionModel{
    
    var subscriptionStatus : Int
    let subscriptionExpiryDate : String
    
    init(_ json : JSON = JSON()){
        subscriptionStatus = json["subscriptionStatus"].intValue
        subscriptionExpiryDate = json["subscriptionExpiryDate"].stringValue
    }
    
    func getDict() -> JSONDictionary{
        return ["subscriptionStatus" : subscriptionStatus , "subscriptionExpiryDate" : subscriptionExpiryDate]
    }
}

struct UserInputModel {
    var firstName: String = ""
    var email: String = ""
    var phone: String = ""
    var password: String = ""
    init() {}
}
