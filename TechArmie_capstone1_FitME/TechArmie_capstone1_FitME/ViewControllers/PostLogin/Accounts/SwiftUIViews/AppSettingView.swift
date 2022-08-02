//
//  AppSettingView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-01.
//

import SwiftUI

struct AppSettingView: View {
    
    private var controller: AppSettingViewController;
    init(controller: AppSettingViewController) {
        self.controller = controller;
    }
    
    var body: some View {
        ScrollView {
                   VStack(){
                       Text("Settings")
                       Image("user_profile")
                       HStack {
                           Spacer()
                           VStack{
                               Text("90.0kg")
                               Text("Target")
                           }
                           Group {
                               Spacer()
                               Divider()
                               Spacer()
                           }
                           VStack{
                               Text("90.0kg")
                               Text("Current")
                           }
                           Group {
                               Spacer()
                               Divider()
                               Spacer()
                           }
                           VStack{
                               Text("0.0kg")
                               Text("Change")
                           }
                           Spacer()
                       }.frame(height: 80).background(Color(CustomColors.white))
                       
                       Button("Change"){
                       }
                       VStack (alignment: .leading){
                           Text ("Account").bold().font(.title3)
                           VStack (spacing: 0) {
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Account Settings")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                               Divider().padding(.horizontal)
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Go For Premium")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                           }.background(Color(CustomColors.white))
                       }.padding()
                       
                       VStack (alignment: .leading){
                           Text ("Social Media").bold().font(.title3)
                           VStack (spacing: 0) {
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Rate us on App Store")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                               Divider().padding(.horizontal)
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Share Fitme with your friends")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                           }.background(Color(CustomColors.white))
                       }.padding()
                       
                       
                       VStack (alignment: .leading){
                           Text ("Help & Support").bold().font(.title3)
                           VStack (spacing: 0) {
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Feedback and Support")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                               Divider().padding(.horizontal)
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Terms Of Service")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                               Divider().padding(.horizontal)
                               Button {
                                   
                               } label: {
                                   HStack {
                                       Text("Privacy Policy")
                                       Spacer()
                                       Image("chevron_left")
                                   }.padding()
                               }
                           }.background(Color(CustomColors.white))
                       }.padding()
                       Button {
                           
                       } label: {
                           Text("Logout").frame(width: 200).padding()
                       }.background(Color(CustomColors.lightGray)).foregroundColor(Color(CustomColors.black)).cornerRadius(15)
                       Button {
                           
                       } label: {
                           Text("Delete Account").foregroundColor(Color.red).padding()
                       }
                       EmptySpace()
                   }.background(Color(CustomColors.gray))
               }
    }
}

struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingView(controller: AppSettingViewController())
    }
}
