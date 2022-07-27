//
//  Structs.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-07-27.
//

import Foundation

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
