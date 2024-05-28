//
//  SignedInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI

struct SignedInView: View {
    
    @Binding var loggedInUser: AuthDataResultModel?
    
    var body: some View {
        
        
        VStack{
            if ( loggedInUser != nil ){
                Form{
                    
                    if ( loggedInUser?.photoUrl != nil ){
                        AsyncImage(url: URL(string: loggedInUser!.photoUrl!)) { image in
                            image.resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(loggedInUser!.email!)
                    
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
