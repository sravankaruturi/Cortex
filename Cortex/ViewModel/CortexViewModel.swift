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
    
    // MARK: Published Vars
    // TODO: Does this need to be published?
    @Published var dbUser: DBAccountInfo? = nil
    
    @Published var items: [ItemModel] = []
    
    @Published var isUserLoggedIn: Bool = false
    
    @AppStorage("tintColor") var tintColor: Color = .brandPrimary
    
    var authManager: AuthenticationManager = AuthenticationManager()
    var userManager: UserManager = UserManager()
    var itemManager: ItemManager?
    
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
        self.itemManager = ItemManager(userId: self.user!.uid)
        
        guard itemManager != nil else {
            print("Item Manager cannot be initialized")
            return
        }
        
        DispatchQueue.main.async {
            Task{
                do {
                    self.items = try await self.itemManager!.getItems()
                }catch {
                    print(error)
                }
            }
        }
        
        
        if ( dbUser != nil ){
            DispatchQueue.main.async {
                self.isUserLoggedIn = true
            }
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
    
    // Split this into multiple functions such that adding an element to the list is tracked by swiftUI and the db call is not for withAnimationCall
    // https://forums.swift.org/t/how-to-use-async-await-with-call-to-withanimation/53969
    func addItem(_ item: ItemModel) async {
        
        if !isUserLoggedIn {
            // TODO: Throw an error
            print("The user is not logged in")
            return
        }
        
        guard dbUser != nil else {
            // TODO: Throw an error
            print("The DB user is nil")
            return
        }
        
        items.append(item)
        
        do {
            try await itemManager!.addItem(item: item)
        }catch {
            print(error)
        }
        
    }
    
    // Split this into multiple functions such that adding an element to the list is tracked by swiftUI and the db call is not for withAnimationCall
    // https://forums.swift.org/t/how-to-use-async-await-with-call-to-withanimation/53969
    func saveItem(_ item: ItemModel) async {
        
        if !isUserLoggedIn {
            // TODO: Throw an error
            print("The user is not logged in")
            return
        }
        
        guard dbUser != nil else {
            // TODO: Throw an error
            print("The DB user is nil")
            return
        }
        
        do {
            try await itemManager!.saveItem(item: item)
        }catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            Task{
                self.items = try await self.itemManager!.getItems()
            }
        }
        
    }
    
    
}
