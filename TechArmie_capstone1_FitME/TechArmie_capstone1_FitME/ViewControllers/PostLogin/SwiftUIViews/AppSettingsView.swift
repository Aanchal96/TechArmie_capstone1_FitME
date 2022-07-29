//
//  AppSettings.swift
//  TechArmie_capstone1_FitME
//
//  Created by Macbbok Pro on 2022-07-29.
//

import SwiftUI

struct AppSettingsView: View {
    
    
    private var controller: AppSettingsViewController;
    init(controller: AppSettingsViewController) {
        self.controller = controller;
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(controller: AppSettingsViewController())
    }
}
