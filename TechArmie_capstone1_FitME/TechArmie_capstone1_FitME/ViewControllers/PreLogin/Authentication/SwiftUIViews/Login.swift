//
//  Login.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-25.
//

import SwiftUI

struct Login: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    
    private var controller: LoginController;
    init(controller: LoginController) {
        self.controller = controller;
    }
    
    func textFieldValidatorEmail(value: String) -> Bool {
        return false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign In").bold().font(.title).padding()
                Group {
                    TextField("Enter Your Email", text: $email, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if textFieldValidatorEmail(value: self.email) {
                                self.isEmailValid = true
                            } else {
                                self.isEmailValid = false
                            }
                        }
                    }).padding(.bottom, isEmailValid ? 20 : 10).overlay(VStack{Divider().offset(x: 0, y: 10)})
                        
                    if !self.isEmailValid {
                        HStack {
                            Text("Invalid email address").font(.caption).foregroundColor(Color(red: 1, green: 0, blue: 0))
                            Spacer()
                        }
                    }
                }
                Group {
                    SecureField("Enter Your Password", text: $password)
                        .padding(.bottom, isEmailValid ? 20 : 10)
                        .overlay(VStack{Divider().offset(x: 0, y: 10)})
                    if !self.isPasswordValid {
                        HStack {
                            Text("Invalid password length").font(.caption).foregroundColor(Color(red: 1, green: 0, blue: 0))
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Forgot Your Password ?")
                }
                
                EmptySpace()
                
                Button {
                    if (password.isBlank || email.isBlank) {
                        if password.isBlank {isPasswordValid = false};
                        if email.isBlank {isEmailValid = false};
                        return
                    }
                    if password.count < 6 {
                        if password.isBlank {isPasswordValid = false}; return;
                    }
                    self.controller.emailPasswordFirebaseLogin(email: email, password: password);
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                }
                .background(Color(red: 0.149, green: 0.259, blue: 0.298))
                .frame(width: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                LabelledDivider(label: "OR", color: Color(red: 0, green: 0, blue: 0))
                Group {
                    Button {
                        self.controller.googleSignInButton()
                    } label: {
                        Spacer()
                        Image("Google")
                        Text("Sign Up with Google")
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color(red: 0.886, green: 0.498, blue: 0.475))
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
//                    EmptySpace(spacing: 5)
//                    Button {
//
//                    } label: {
//                        Spacer()
//                        Image("Apple")
//                        Text("Sign Up with Apple")
//                            .foregroundColor(.white)
//                            .padding()
//                            .padding(.trailing, 12)
//                        Spacer()
//                    }
//                    .background(Color(red: 0, green: 0, blue: 0))
//                    .frame(width: 300)
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
            
    }
}

struct EmptySpace: View {
    let spacing: CGFloat;
    
    init(spacing: CGFloat = 20) {
        self.spacing = spacing;
    }
    
    var body: some View {
        Section(header: Text("")) {
            EmptyView()
        }.padding(.bottom, spacing)
    }
}

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).bold().foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().frame(height: 2).background(color) }.padding(horizontalPadding)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(controller: LoginController())
    }
}
