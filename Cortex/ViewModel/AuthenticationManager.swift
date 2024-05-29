//
//  AuthenticationManager.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

struct AuthDataResultModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    private init(uid: String, email: String?, photoUrl: String?){
        self.uid = uid
        self.email = email
        self.photoUrl = photoUrl
    }
    
    static let mockData: AuthDataResultModel = AuthDataResultModel(uid: "01", email: "mockdata@mockdata.com", photoUrl: "https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/007.png")
    
    // mockdata@mockdata.com - TestPass
    
}

// Remove this.
final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {
        
    }

    
//    func signInWithGoogle() {
//        
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
//          guard error == nil else {
//            // ...
//          }
//
//          guard let user = result?.user,
//            let idToken = user.idToken?.tokenString
//          else {
//            // ...
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: user.accessToken.tokenString)
//
//          // ...
//        }
//        
//    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
        
    }
    

}

// MARK: Sign in Email
extension AuthenticationManager{
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
        
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
        
    }
    
    func resetPassword(email: String) async throws {
        try await  Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOutCurrentUser() throws {
        try Auth.auth().signOut()
    }
    
    func updatePassword(newPassword: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
    
    func updateEmail(email: String) async throws {
        try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    
}

// MARK: Sign in SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithCredential(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
