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
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView{
                ListView()
            }
            .environmentObject(listViewModel)
        }
        .modelContainer(for: ItemModel.self)
    }
}
