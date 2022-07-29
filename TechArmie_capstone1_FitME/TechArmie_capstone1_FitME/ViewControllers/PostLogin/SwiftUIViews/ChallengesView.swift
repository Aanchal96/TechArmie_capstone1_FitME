//
//  ChallengesView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-28.
//

import SwiftUI

struct ChallengesView: View {
    
    private var controller: ChallengesViewController;
    init(controller: ChallengesViewController) {
        self.controller = controller;
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("30 Days Challenge").font(.title).bold().padding(.bottom, -5).padding(.horizontal, 10)
                    Divider().frame(height: 1).background(Color(CustomColors.lightGray))
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Beginner Challenges").font(.title3).bold()
                        Text("Get started with Easy and effective challenges designed for the total beginners")
                            .font(.body)
                        ScrollView(.horizontal, showsIndicators: false)  {
                            HStack (spacing: 15) {
                                ForEach(0...10, id: \.self) { i in
                                    Button {
                                        self.controller.goToDetailView();
                                    } label: {
                                        ZStack (alignment: .center) {
                                            GeometryReader { geometry in
                                                Image("dummy_workout").resizable().scaledToFill().frame(width: geometry.size.width)
                                            }
                                            Text("LOW IMPACT CARDIO").font(.title2).bold().multilineTextAlignment(.center)
                                        }.cornerRadius(15.0).frame(width: 150, height: 300).foregroundColor(Color(CustomColors.white))
                                    }
                                    
                                }
                            }
                        }
                        Text("Intermediate Challenges").font(.title3).bold()
                        Text("Get started with Easy and effective challenges designed for the total beginners")
                            .font(.body)
                        ScrollView(.horizontal, showsIndicators: false)  {
                            HStack (spacing: 15) {
                                ForEach(0...10, id: \.self) { i in
                                    ZStack (alignment: .center) {
                                        GeometryReader { geometry in
                                            Image("dummy_workout").resizable().scaledToFill().frame(width: geometry.size.width)
                                        }
                                        Text("LOW IMPACT CARDIO").font(.title2).bold().multilineTextAlignment(.center)
                                    }.cornerRadius(15.0).frame(width: 150, height: 300).foregroundColor(Color(CustomColors.white))
                                }
                            }
                        }
                        Text("Advanced Challenges").font(.title3).bold()
                        Text("Get started with Easy and effective challenges designed for the total beginners")
                            .font(.body)
                        ScrollView(.horizontal, showsIndicators: false)  {
                            HStack (spacing: 15) {
                                ForEach(0...10, id: \.self) { i in
                                    ZStack (alignment: .center) {
                                        GeometryReader { geometry in
                                            Image("dummy_workout").resizable().scaledToFill().frame(width: geometry.size.width)
                                        }
                                        Text("LOW IMPACT CARDIO").font(.title2).bold().multilineTextAlignment(.center)
                                    }.cornerRadius(15.0).frame(width: 150, height: 300).foregroundColor(Color(CustomColors.white))
                                }
                            }
                        }
                    }.padding(.horizontal, 10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView(controller: ChallengesViewController())
    }
}
