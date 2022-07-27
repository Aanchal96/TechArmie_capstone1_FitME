//
//  WorkoutView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-26.
//

import SwiftUI

struct WorkoutView: View {
    
    @State var tabIndex = 0
    
    private var controller: WorkoutController;
    init(controller: WorkoutController) {
        self.controller = controller;
    }
    
    var body: some View {
        NavigationView {
                VStack(alignment: .center) {
                    ZStack(alignment: .center) {
                        Image("workout_bg").resizable(resizingMode: .stretch)
                        VStack {
                            Text("Workout").font(.title).foregroundColor(.white)
                            Text("Plan").font(.subheadline).foregroundColor(.white)
                        }
                    }.frame(height: 250)
                    CustomTopTabBar(tabIndex: $tabIndex)
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Workouts for Week 1")
                            GeometryReader { geometry in
                                        ZStack {
                                            Rectangle().frame(width: geometry.size.width , height: 5)
                                                .foregroundColor(Color(CustomColors.lightGray))
                                        }.cornerRadius(45.0)
                            }
                            EmptySpace(spacing: -2)
                        }.padding().background(Color(CustomColors.gray)).cornerRadius(15.0).padding().frame(height: 80)
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(0...10, id: \.self) { i in
                                ZStack (alignment: .leading) {
                                    GeometryReader { geometry in
                                        Image("dummy_workout").resizable().scaledToFill().frame(width: geometry.size.width)
                                    }
                                    VStack (alignment: .leading) {
                                        Text("Day 1").font(.title).bold()
                                        Text("Core Routine").font(.subheadline).bold()
                                        Spacer()
                                        HStack  (alignment: .top) {
                                            Text("⏱ 16 min").font(.title3)
                                        }
                                        HStack  (alignment: .top) {
                                            Image("Calories")
                                            Text("82 Kcal").font(.title3)
                                        }
                                    }.padding()
                                }.cornerRadius(15.0).frame(height: 300).foregroundColor(Color(CustomColors.white))
                                
                            }
                        }.padding(.horizontal)
                    }
                    Spacer()
                }
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea([.top])
            }
        }
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 30) {
            Spacer()
            TabBarButton(text: "Week 1", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            TabBarButton(text: "Week 2", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            TabBarButton(text: "Week 3", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
            TabBarButton(text: "Week 4", isSelected: .constant(tabIndex == 3))
                .onTapGesture { onButtonTapped(index: 3) }
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Avenir", size: 16))
            .padding(.vertical, 15)
            .border(width: isSelected ? 3 : 1, edges: [.bottom], color: .black)
    }
}


extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(controller: WorkoutController())
    }
}
