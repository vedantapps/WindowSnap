//
//  ContentView.swift
//  WindowSnap
//
//  Created by Vedant Malhotra on 6/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isDragging = false
    @State private var dragOffset = CGSize.zero
    @State private var boxPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    @State private var boxFrameHeight = 450.0
    @State private var boxFrameWidth = 450.0
    
    @State private var topL = false
    @State private var botL = false
    @State private var cenL = false
    @State private var topR = false
    @State private var botR = false
    @State private var cenR = false
    
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 25)
                .frame(width: boxFrameWidth, height: boxFrameHeight)
                .foregroundColor(.white)
                .shadow(radius: 5)
                .overlay {
                    VStack {
                        Image(systemName: "macwindow.on.rectangle")
                        Text("WindowSnap")
                        Text("SwiftUI powered window snapping")
                            .font(.title2)
                            .padding(.top)
                            .bold(false)
                        Button {
                            withAnimation {
                                boxPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                                boxFrameWidth = 450.0
                                boxFrameHeight = 450.0
                            }
                        } label: {
                            HStack {
                                Image(systemName: "window.casement")
                                Text("Recenter Window")
                            }
                            .font(.title2)
                            .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.title)
                    .bold()
                    .padding()
                    .foregroundColor(.black)
                }
                .position(boxPosition)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isDragging = true
                                if gesture.translation.height < -80 && gesture.location.x < 250 {
                                    // Top Left
                                    topL = true
                                    botL = false
                                    cenL = false
                                } else if gesture.translation.height > 80 && gesture.location.x < 250 {
                                    // Bottom Left
                                    topL = false
                                    botL = true
                                    cenL = false
                                } else if gesture.location.x < 250 {
                                    // Center Left
                                    topL = false
                                    botL = false
                                    cenL = true
                                } else if gesture.translation.height < -80 && gesture.location.x > 850 {
                                    // Top Right
                                    topR = true
                                    botR = false
                                    cenR = false
                                } else if  gesture.translation.height > 80 && gesture.location.x > 850 {
                                    // Bottom Right
                                    topR = false
                                    botR = true
                                    cenR = false
                                } else if gesture.location.x > 850 {
                                    topR = false
                                    botR = false
                                    cenR = true
                                } else {
                                    topL = false
                                    botL = false
                                    cenL = false
                                    topR = false
                                    botR = false
                                    cenR = false
                                }
                            }
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isDragging = false
                            }
                            boxPosition = boxPosition + gesture.translation
                            dragOffset = .zero
                            withAnimation {
                                if cenL == true {
                                    print("Center, Left")
                                    boxFrameHeight = UIScreen.main.bounds.height
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height/2)
                                } else if topL == true {
                                    print("Top, Left")
                                    boxFrameHeight = UIScreen.main.bounds.height / 2
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height/4)
                                } else if botL == true {
                                    print("Bottom, Left")
                                    boxFrameHeight = UIScreen.main.bounds.height / 2
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height - boxFrameHeight / 2)
                                } else if cenR == true {
                                    print("Center, Right")
                                    boxFrameHeight = UIScreen.main.bounds.height
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width - boxFrameWidth / 2, y: UIScreen.main.bounds.height/2)
                                } else if topR == true {
                                    print("Top, Right")
                                    boxFrameHeight = UIScreen.main.bounds.height / 2
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width - boxFrameWidth / 2, y: UIScreen.main.bounds.height/4)
                                } else if botR == true {
                                    print("Bottom, Right")
                                    boxFrameHeight = UIScreen.main.bounds.height / 2
                                    boxFrameWidth = UIScreen.main.bounds.width / 2
                                    boxPosition = CGPoint(x: UIScreen.main.bounds.width - boxFrameWidth / 2, y: UIScreen.main.bounds.height - boxFrameHeight / 2)
                                }
                            }
                        }
                )
                .zIndex(2)
            
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 70, height: UIScreen.main.bounds.height)
                    .foregroundColor(Color.blue.opacity(0.5))
                    .offset(x: isDragging ? 0 : -UIScreen.main.bounds.width)
                    .offset(y: topL ? -UIScreen.main.bounds.height / 2 : 0)
                    .offset(y: botL ? UIScreen.main.bounds.height / 2 : 0)
                Spacer()
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 70, height: UIScreen.main.bounds.height)
                    .foregroundColor(Color.blue.opacity(0.5))
                    .offset(x: isDragging ? 0 : UIScreen.main.bounds.width)
                    .offset(y: topR ? -UIScreen.main.bounds.height / 2 : 0)
                    .offset(y: botR ? UIScreen.main.bounds.height / 2 : 0)
            }
            .zIndex(1)
            Spacer()
        }
        .background {
            Image("Sonoma")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGSize) -> CGPoint {
        CGPoint(x: left.x + right.width, y: left.y + right.height)
    }
}
