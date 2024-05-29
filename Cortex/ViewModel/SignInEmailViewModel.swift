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
    
    public func signIn() async {
        
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found")
            return
        }
        
        var res = try? await AuthenticationManager.shared.signInUser(email:email, password: password)
        if ( res == nil ){
            res = try? await AuthenticationManager.shared.createUser(email: email, password: password)
        }
        
        if ( res == nil ){
            print("Unable to login or create account")
        }
        
        user = res
        
    }
    
    public func createUser() async {
        _ = try? await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
}
