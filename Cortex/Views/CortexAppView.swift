//
//  ContentView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData

struct CortexAppView: View {
    
    @EnvironmentObject var cortexVM: CortexViewModel

    var body: some View {
        
        ZStack{
            if ( cortexVM.isUserLoggedIn ){
                TabView{
                    ListView()
                        .badge(cortexVM.items.count)
                        .tabItem { Label("To Do", systemImage: "checklist") }
                    
                    PomoView()
                        .tabItem { Label("Pomo", systemImage: "timer.circle.fill") }
                    
#if os(iOS)
                    BarcodeScanner()
                        .tabItem { Label("Barcode", systemImage: "barcode.viewfinder") }
#endif
                    
                    AccountView()
                        .tabItem { Label("Account", systemImage: "person.crop.circle")}
                    
                }
                
            }else {
                VStack{
                    Text("Please Sign in")
                        .padding()
                    SignInView(userLoggedIn: $cortexVM.isUserLoggedIn )
                }
            }
        }
        .tint(cortexVM.tintColor)
        .onAppear{
            Task{
                await cortexVM.onAppAppear()
            }
        }

    }
}

#Preview {
    CortexAppView()
}
