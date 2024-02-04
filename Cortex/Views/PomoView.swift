//
//  PomoView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 10/16/23.
//

import SwiftUI

struct PomoView: View {
    
    @StateObject private var  pvm = PomoViewModel()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Text("Pomodoro Timer")
                    .font(.title)
                    .padding(50)

                Spacer()
                
                ZStack{
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(Circle().trim(from: 0.0, to: CGFloat(pvm.percentageDone)).stroke(style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round,
                                lineJoin: .round
                            )).foregroundColor(.orange)
                        )
                    
                    Text(pvm.time)
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                HStack(spacing: 10, content: {
                    
                    Spacer()
                    
                    Button(action: {
                        pvm.start()
                    }, label: {
                        Text("Start")
                            .font(.title2)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        pvm.reset()
                    }, label: {
                        Text("Reset")
                            .font(.title2)
                            .padding()
                    })
                    
                    Spacer()
                })
                .padding()
                .onReceive(timer, perform: { _ in
                    pvm.updateCountDown()
                })
            }
        }
        .navigationTitle("Pomodoro Timer")
    }
}

#Preview {
    TabView{
        PomoView()
            .tabItem { Image(systemName: "timer") }
    }
}
