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
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        VStack{
            
            if !cortexVM.isUserLoggedIn {
                
                SignInView(userLoggedIn: $cortexVM.isUserLoggedIn)

            }else{
                
                SettingsView()
                
            }
            
            Spacer()
            
        }
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        AccountView()
    }
}
