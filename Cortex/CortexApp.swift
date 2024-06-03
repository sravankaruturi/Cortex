//
//  CortexApp.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct CortexApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var cortexViewModel = CortexViewModel()

    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
        }
        .modelContainer(for: ItemModel.self)
        .environmentObject(cortexViewModel)
    }
}
