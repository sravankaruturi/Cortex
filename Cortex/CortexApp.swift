//
//  CortexApp.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/24/23.
//

import SwiftUI
import SwiftData
import CoreData
import FirebaseCore
import FirebaseFirestore


@main
struct CortexApp: App {
    
    @StateObject private var cortexViewModel = CortexViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        return true
    }
}
