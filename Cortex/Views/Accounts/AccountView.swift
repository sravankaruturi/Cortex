//
//  AccountView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AccountView: View {
    
    @State private var userLoggedIn: Bool = false
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        VStack{
            
            if !userLoggedIn {
                
                SignInView(userLoggedIn: $userLoggedIn)
                
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
