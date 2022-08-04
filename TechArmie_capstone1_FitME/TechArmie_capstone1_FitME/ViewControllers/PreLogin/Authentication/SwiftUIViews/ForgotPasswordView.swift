//
//  ForgotPasswordView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-04.
//

import SwiftUI

struct ForgotPasswordView: View {
    private var controller: ForgotPasswordViewController;
    init(controller: ForgotPasswordViewController) {
        self.controller = controller;
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(controller: ForgotPasswordViewController())
    }
}
