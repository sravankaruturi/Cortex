//
//  AccountView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AccountViewModel : ObservableObject{
    
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
        
        return try await AuthenticationManager.shared.signInWithCredential(credential: credential)
        
    }
    
}

struct AccountView: View {
    
    @State private var userLoggedIn: Bool = false
    @StateObject private var vm: AccountViewModel = AccountViewModel()
    
    var body: some View {
        VStack{
            
            if !userLoggedIn {
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(style: .wide)) {
                    Task{
                        do{
                            let user = try await vm.signInGoogle()
                            userLoggedIn = (user != nil)
                        }catch{
                            print(error)
                        }
                    }
                }
                .frame(height: 55)
                .padding()
                
            }else{
                
                SettingsView(isUserLoggedIn: $userLoggedIn)
                
            }
            
            Spacer()
            
        }
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            let user = try? AuthenticationManager.shared.getAuthenticatedUser()
            userLoggedIn = (user != nil)
        })
    }
}

#Preview {
    NavigationStack{
        AccountView()
    }
}
