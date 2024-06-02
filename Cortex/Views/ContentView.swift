//
//  ContentView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<ItemModel>{!$0.isCompleted}, sort: \ItemModel.sortOrder, animation: .easeInOut(duration: 0.5)) var incompleteItems: [ItemModel]
    
    @State var tintColor: Color = .brandPrimary
    
    @EnvironmentObject var cortexVM: CortexViewModel

    var body: some View {
        TabView{
            ListView()
                .badge(incompleteItems.count)
                .tabItem { Label("To Do", systemImage: "checklist") }
            
            PomoView()
                .tabItem { Label("Pomo", systemImage: "timer.circle.fill") }
            
            RecognizerView()
                .tabItem { Label("Recognizer", systemImage: "camera.fill") }
            
            AccountView()
                .tabItem { Label("Account", systemImage: "person.crop.circle")}
            
        }
        .tint(tintColor)
        .onAppear{
            // TODO: Store this in UserDefaults instead of waiting for the server to respond.
            Task{
                do {
                    let user = try cortexVM.authManager.getAuthenticatedUser()
                    let dbUser = try await cortexVM.userManager.getUser(userId: user.uid)
                    withAnimation {
                        tintColor = dbUser.accentColor
                    }
                }catch {
                    // DO NOTHING
                }
            }
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(for: ItemModel.self)
}
