//
//  ForgotPasswordView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-04.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPopupShown: Bool = false
    @State private var isLoading: Bool = false
    
    private var controller: ForgotPasswordViewController;
    init(controller: ForgotPasswordViewController) {
        self.controller = controller;
    }
    
    
    func textFieldValidatorEmail(value: String) -> Bool {
        return email.checkIfValid(.email)
    }
    
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                VStack (alignment: .center) {
                    Text("Forget your password?").bold().font(.title)
                    Image("Thumbs-up 1").frame(width: 100, height: 100).padding()
                    
                    TextField("Enter Your Email", text: $email, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if textFieldValidatorEmail(value: self.email) {
                                self.isEmailValid = true
                            } else {
                                self.isEmailValid = false
                            }
                        }
                    }).padding(.bottom, isEmailValid ? 20 : 10).overlay(VStack{Divider().offset(x: 0, y: 10)})
                    Button {
                        if (email.isBlank) {
                            if email.isBlank {isEmailValid = false};
                            return
                        }
                        isEmailValid = true;
                        isLoading = true;
                        self.controller.sendPasswordResetLink(email: email) {
                            isPopupShown = true
                        } completion: {
                            isLoading = false;
                        }
                    } label: {
                        Text("SUBMIT")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                    }
                    .background(Color(red: 0.149, green: 0.259, blue: 0.298))
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }.padding()
            }.actionSheet(isPresented: $isPopupShown) {
                ActionSheet(
                    title: Text("Notice"),
                    message: Text("Link has been sent to your registered email"),
                    buttons: [
                        .default(Text("Okay")) {
                            self.controller.navigationController?.popViewController(animated: true)
                        }
                    ]
                )
            }
        }
        
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    Text("Loading...")
                    ProgressView()
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(controller: ForgotPasswordViewController())
    }
}
