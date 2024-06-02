//
//  AppDelegate.swift
//  Cortex
//
//  Created by Sravan Karuturi on 6/2/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        return true
    }
}
