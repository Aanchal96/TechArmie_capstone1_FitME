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
                Spacer()
                VStack{
                    Text("90.0kg")
                    Text("Target")
                }
                
                Spacer()
                
                
                
                Divider().frame(height: 80)
                
                Spacer()
                VStack{
                    Text("90.0kg")
                    Text("Current")
                    Button("Change"){
                        
                        
                    }
                    }
                Spacer()
                
                
                
                Divider().frame(height: 80)
                Spacer()
                VStack{
                    Text("0.0kg")
                    Text("Change")
                    }
               }
           
            Form{
                Section(header: Text ("Account")){
                Text ("Account Settings")
                Text("Go For Premium")
                }
                
            
        
            }
            
            
            Form{
                Section(header: Text ("Account")){
                Text ("Account Settings")
                Text("Go For Premium")
                }
        
       
        
        }
        
        
    }


struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(controller: AppSettingsViewController())
    }
}
