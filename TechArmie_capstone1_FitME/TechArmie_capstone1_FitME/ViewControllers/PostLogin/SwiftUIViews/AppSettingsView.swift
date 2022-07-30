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
        
     
        VStack(){
        
            Text("Settings")
            Image("user_profile")
            HStack{
               
            }
            HStack{
                
            }
            HStack{}
            Form{
                
            }
            Spacer()
        }
        
        
    }
}

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(controller: AppSettingsViewController())
    }
}
