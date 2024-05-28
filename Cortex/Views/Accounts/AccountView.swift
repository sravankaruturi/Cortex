//
//  AccountView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    
    @State private var userLoggedIn: AuthDataResultModel? = nil
    
    var body: some View {
        VStack{
            
            if userLoggedIn == nil  {
                
                NavigationLink {
                    
                    SignInEmailView(loggedInUser: $userLoggedIn)
                    
                } label: {
                    Text("Sign in with Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    
                }
                
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
