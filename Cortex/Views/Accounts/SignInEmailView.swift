//
//  SignInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI
import FirebaseAuth

struct SignInEmailView: View {
    
    @StateObject var vm: SignInEmailViewModel = SignInEmailViewModel()
    @Binding var loggedInUser: AuthDataResultModel?
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        
        VStack{
            
            TextField("Email...", text: $vm.email)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            SecureField("Password...", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                Task{
                    await vm.signIn(authManager: cortexVM.authManager)
                    DispatchQueue.main.async {
                        loggedInUser = vm.user
                    }
                    self.dismiss()
                }
            } label: {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical)
            }
            
            Spacer()
            
        }
        .navigationTitle("Sign in with Email")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

#Preview {
    NavigationStack{
        SignInEmailView(loggedInUser: .constant(AuthDataResultModel.mockData))
    }
}
