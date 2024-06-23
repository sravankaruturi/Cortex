//
//  ListViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/26/23.
//

/*
 CRUD
 
 Create
 Read
 Update
 Delete
 */

import Foundation
import UserNotifications
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import SwiftUI

@MainActor
class CortexViewModel: ObservableObject{
    
    // Not Published.
    var user: AuthDataResultModel? = nil
    var dbUser: DBAccountInfo? = nil
    
    @AppStorage("tintColor") var tintColor: Color = .brandPrimary
    
    var authManager: AuthenticationManager = AuthenticationManager()
    var userManager: UserManager = UserManager()
    
    @Published var isUserLoggedIn: Bool = false
    
    init() {
        
        refreshCurrentUser()
        
    }
    
    func refreshCurrentUser() {
        
        Task{
            do {
                try await loadCurrentUser()
            }catch {
                print(error)
            }
        }
        
    }
    
    func onAppAppear() async {
        
        do {
            try await loadCurrentUser()
            withAnimation {
                self.tintColor = dbUser!.accentColor
            }
        }catch {
            // DO NOTHING
        }
        
    }
    
    func loadCurrentUser() async throws {
        
        self.user = try authManager.getAuthenticatedUser()
        self.dbUser = try await userManager.getUser(userId: self.user!.uid)
        
        if ( dbUser != nil ){
            isUserLoggedIn = true
        }
        
    }
    
    func setColor(newColor: Color) async throws {
        dbUser?.accentColor = newColor
        withAnimation {
            tintColor = newColor
        }
        try await userManager.updateUser(accountInfo: dbUser!)
    }
    
    func signInGoogle() async throws -> AuthDataResultModel? {
        
        guard let topVC = UIApplication.topViewController() else {
            throw URLError(.badServerResponse, userInfo: ["Info": "Cannot find top View controller"])
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw URLError(.badServerResponse, userInfo: ["Info" : "Cannot find Client ID"])
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse, userInfo: ["Info": "Cannot find ID Token"])
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return try await authManager.signInWithCredential(credential: credential, userManager: userManager)
        
    }
    
    
}
