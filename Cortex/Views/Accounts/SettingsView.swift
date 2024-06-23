//
//  SignedInView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/27/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State var col: Color = .white
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        
        VStack{
            if ( cortexVM.isUserLoggedIn && cortexVM.user != nil && cortexVM.dbUser != nil ){
                List{
                    
                    Section("Profile Picture") {
                        if ( cortexVM.user?.photoUrl != nil ){
                            AsyncImage(url: URL(string: cortexVM.user!.photoUrl!)) { image in
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
                        Text(cortexVM.user!.email!)
                        Text("Date Created: \(cortexVM.dbUser!.dateCreated?.formatted() ?? "Not available")")
                    }
                    
                    Section("Settings") {
                        ColorPicker("Accent Color", selection: $col)
                            .onChange(of: col) { oldValue, newValue in
                                Task{
                                    try? await self.cortexVM.setColor(newColor: col);
                                }
                            }
                    }
                    
                    Section("Actions"){
                        
                        Button {
                            
                            do {
                                try cortexVM.authManager.signOutCurrentUser()
                                cortexVM.isUserLoggedIn = false
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
                        cortexVM.isUserLoggedIn = false
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
                cortexVM.refreshCurrentUser()
                if ( cortexVM.dbUser != nil ){
                    col = cortexVM.dbUser!.accentColor
                }
            }
        })
        
    }
}

#Preview {
    NavigationStack{
        SettingsView()
    }
}
