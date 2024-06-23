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

struct AccountView: View {
    
    @State private var userLoggedIn: Bool = false
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        VStack{
            
            if !userLoggedIn {
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(style: .wide)) {
                    Task{
                        do{
                            let user = try await cortexVM.signInGoogle()
                            userLoggedIn = (user != nil)
                        }catch{
                            print(error)
                        }
                    }
                }
                .frame(height: 55)
                .padding()
                
            }else{
                
                SettingsView()
                
            }
            
            Spacer()
            
        }
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            let user = try? cortexVM.authManager.getAuthenticatedUser()
            userLoggedIn = (user != nil)
        })
    }
}

#Preview {
    NavigationStack{
        AccountView()
    }
}
