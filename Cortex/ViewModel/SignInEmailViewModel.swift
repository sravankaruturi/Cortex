//
//  SignInEmailViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import Foundation

final class SignInEmailViewModel : ObservableObject {
    
    public var email = ""
    public var password = ""
    
    public var user: AuthDataResultModel? = nil
    
    public func signIn(authManager: AuthenticationManager) async {
        
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found")
            return
        }
        
        var res = try? await authManager.signInUser(email:email, password: password)
        if ( res == nil ){
            res = try? await authManager.createUser(email: email, password: password)
        }
        
        if ( res == nil ){
            print("Unable to login or create account")
        }
        
        user = res
        
    }
    
    public func createUser(authmanager: AuthenticationManager) async {
        _ = try? await authmanager.createUser(email: email, password: password)
    }
    
}
