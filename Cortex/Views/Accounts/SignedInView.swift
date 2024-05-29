//
//  SignedInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI

struct SignedInView: View {
    
    @Binding var loggedInUser: AuthDataResultModel?
    
    @State var showChangeEmail: Bool = false
    
    var body: some View {
        
        
        VStack{
            if ( loggedInUser != nil ){
                List{
                    
                    Section("Profile Picture") {
                        if ( loggedInUser?.photoUrl != nil ){
                            AsyncImage(url: URL(string: loggedInUser!.photoUrl!)) { image in
                                image.resizable()
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }else{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                            
                            Button {
                                // TODO: Implement this.
                            } label: {
                                Text("Add Image")
                            }
                        }
                    }
                    
                    Section("Account Details"){
                        Text(loggedInUser!.email!)
                    }
                    
                    Section("Actions"){
                        
//                        Button {
//                            guard let email = loggedInUser?.email else {
//                                print("Unable to access email")
//                                return
//                            }
//                            
//                            Task{
//                                do {
//                                    try await AuthenticationManager.shared.resetPassword(email: loggedInUser!.email!)
//                                } catch{
//                                    print(error)
//                                }
//                            }
//                            
//                        } label: {
//                            Text("Reset Password")
//                        }
//                        
//                        Button {
//                            // TODO: Open Change Password
//                        } label: {
//                            Text("Update Password")
//                        }
//                        
//                        Button {
//                            showChangeEmail = true
//                        } label: {
//                            Text("Update Email")
//                        }.sheet(isPresented: $showChangeEmail) {
//                            UpdateEmailView(oldEmail: "", newEmail: "")
//                                .presentationDetents([.medium])
//                        }
                        
                        Button {
                            
                            do {
                                try AuthenticationManager.shared.signOutCurrentUser()
                                loggedInUser = nil
                                // TODO: Programatically navigate to home.
                            }catch {
                                print(error)
                            }
                            
                        } label: {
                            Text("Sign out of Account")
                        }
                    }
                    
                }
            }
            
        }
        .padding()
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            if loggedInUser == nil {
                loggedInUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            }
        })
        
    }
}

#Preview {
    NavigationStack{
        SignedInView(loggedInUser: .constant(AuthDataResultModel.mockData))
    }
}
