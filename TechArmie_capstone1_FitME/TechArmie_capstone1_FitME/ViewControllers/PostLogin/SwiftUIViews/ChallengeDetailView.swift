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
        ZStack {
            Color(CustomColors.lightGray).ignoresSafeArea(.all, edges: [.top, .bottom])
            VStack {
                HStack {
                    Image("dummy_workout").resizable().scaledToFill().frame(width: 150)
                        .cornerRadius(15.0)
                        .frame(width: 150, height: 250).foregroundColor(Color(CustomColors.white))
                    VStack(alignment: .leading) {
                        Text("Hello").font(.title2).bold()
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse est leo, vehicula eu eleifend non, auctor ut arcu")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }.padding()
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) {
                            ForEach(1...30, id: \.self) { i in
                                ZStack (alignment: .center) {
                                    Circle().foregroundColor(Color(CustomColors.lightGray))
                                    Text("\(i)").font(.body).padding()
                                }
                            }
                        }.padding()
                    }
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Spacer()
                        Text("Join Challenge")
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color(red: 0.886, green: 0.498, blue: 0.475))
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)).padding(.bottom, 20)
                    Spacer()
                }.background(Color(CustomColors.white))
                    .cornerRadius(30)
                    .ignoresSafeArea(.all, edges: [.bottom])
            }
        }
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView(controller: ChallengeDetailViewController())
            
    }
}
