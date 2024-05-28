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
    @Query private var items: [ItemModel]

    var body: some View {
        TabView{
            ListView()
                .badge(items.count)
                .tabItem { Label("To Do", systemImage: "checklist") }
            
            PomoView()
                .tabItem { Label("Pomo", systemImage: "timer.circle.fill") }
            
            AccountView()
                .tabItem { Label("Account", systemImage: "person.crop.circle")}
            
        }
        .tint(Color.brandPrimary)

    }
}

#Preview {
    ContentView()
        .modelContainer(for: ItemModel.self)
}
