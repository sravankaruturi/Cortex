//
//  CortexApp.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData
import CoreData


/*
 
 MVVM - Architecture
 
 Model - Data Points
 View - UI
 ViewModel - Manages Models for Views.
 
 */

@main
struct CortexApp: App {
    
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
