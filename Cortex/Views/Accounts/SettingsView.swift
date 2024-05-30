//
//  SignedInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    
    @Binding var isUserLoggedIn: Bool
    @State var col: Color = .white
    
    var body: some View {
        
        VStack{
            if ( isUserLoggedIn && viewModel.user != nil && viewModel.dbUser != nil ){
                List{
                    
                    Section("Profile Picture") {
                        if ( viewModel.user?.photoUrl != nil ){
                            AsyncImage(url: URL(string: viewModel.user!.photoUrl!)) { image in
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
                        Text(viewModel.user!.email!)
                        Text("Date Created: \(viewModel.dbUser!.dateCreated?.formatted() ?? "Not available")")
                    }
                    
                    Section("Settings") {
                        ColorPicker("Accent Color", selection: $col)
                            .onChange(of: col) { oldValue, newValue in
                                Task{
                                    try? await self.viewModel.setColor(newColor: col);
                                }
                            }
                    }
                    
                    Section("Actions"){
                        
                        Button {
                            
                            do {
                                try AuthenticationManager.shared.signOutCurrentUser()
                                isUserLoggedIn = false
                                // TODO: Programatically navigate to home.
                            }catch {
                                print(error)
                            }
                            
                        } label: {
                            Text("Sign out of Account")
                        }
                    }
                    
                }
            }else{
                VStack(spacing: 20){
                    Text("Not Logged In")
                    Button {
                        isUserLoggedIn = false
                    } label: {
                        Text("Go Back")
                    }
                }

            }
        }
        .padding()
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            Task{
                do {
                    try await viewModel.loadCurrentUser()
                    if ( viewModel.dbUser != nil ){
                        col = viewModel.dbUser!.accentColor
                    }
                }catch{
                    isUserLoggedIn = false
                }
            }
        })
        
    }
}

#Preview {
    NavigationStack{
        SettingsView(isUserLoggedIn: .constant(true))
    }
}
