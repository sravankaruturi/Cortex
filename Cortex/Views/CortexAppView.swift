//
//  ContentView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData

struct CortexAppView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<ItemModel>{!$0.isCompleted}, sort: \ItemModel.sortOrder, animation: .easeInOut(duration: 0.5)) var incompleteItems: [ItemModel]
    
    @EnvironmentObject var cortexVM: CortexViewModel

    var body: some View {
        
        ZStack{
            if ( cortexVM.isUserLoggedIn ){
                TabView{
                    ListView()
                        .badge(incompleteItems.count)
                        .tabItem { Label("To Do", systemImage: "checklist") }
                    
                    PomoView()
                        .tabItem { Label("Pomo", systemImage: "timer.circle.fill") }
                    
                    RecognizerView()
                        .tabItem { Label("Recognizer", systemImage: "camera.fill") }
                    
                    BarcodeScanner()
                        .tabItem { Label("Barcode", systemImage: "barcode.viewfinder") }
                    
                    AccountView()
                        .tabItem { Label("Account", systemImage: "person.crop.circle")}
                    
                }
                
            }else {
                VStack{
                    Text("Unfortunately, it is required to sign in with your google account for now.")
                        .padding()
                    AccountView()
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
        .modelContainer(for: ItemModel.self)
}
