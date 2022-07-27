//
//  WorkoutView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-26.
//

import SwiftUI

struct WorkoutView: View {
    
    private var controller: WorkoutController;
    init(controller: WorkoutController) {
        self.controller = controller;
    }
    
    var body: some View {
        Text("Workout")
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(controller: WorkoutController())
    }
}
