//
//  SignInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 6/24/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignInView: View {
    
    @EnvironmentObject var cortexVM: CortexViewModel
    @Binding var userLoggedIn: Bool
    
    var body: some View {
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
    }
}

#Preview {
    SignInView(userLoggedIn: .constant(false))
}
