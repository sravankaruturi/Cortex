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
    
    @State private var userLoggedIn: AuthDataResultModel? = nil
    @StateObject private var vm: AccountViewModel = AccountViewModel()
    
    var body: some View {
        VStack{
            
            if userLoggedIn == nil  {
                
//                NavigationLink {
//                    
//                    SignInEmailView(loggedInUser: $userLoggedIn)
//                    
//                } label: {
//                    Text("Sign in with Email")
//                        .font(.headline)
//                        .foregroundStyle(.white)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.brandPrimary)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding()
//                    
//                }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(style: .wide)) {
                    Task{
                        do{
                            userLoggedIn = try await vm.signInGoogle()
                        }catch{
                            print(error)
                        }
                    }
                }
                .frame(height: 55)
                .padding()
                
            }else{
                
                SignedInView(loggedInUser: $userLoggedIn)
                
            }
            
            Spacer()
            
        }
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            userLoggedIn = try? AuthenticationManager.shared.getAuthenticatedUser()
        })
    }
}

#Preview {
    NavigationStack{
        AccountView()
    }
}
