//
//  ChallengeDetailView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-28.
//

import SwiftUI

struct ChallengeDetailView: View {
    
    private var controller: ChallengeDetailViewController;
    init(controller: ChallengeDetailViewController) {
        self.controller = controller;
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView(controller: ChallengeDetailViewController())
    }
}
