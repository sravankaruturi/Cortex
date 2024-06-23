//
//  UpdateEmailView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/28/24.
//

import SwiftUI
import FirebaseAuth

struct UpdateEmailView: View {
    
    @State var oldEmail: String? = Auth.auth().currentUser?.email
    @State var newEmail: String
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var cortexVM: CortexViewModel
    
    var body: some View {
        
        Form{
            
            Text(oldEmail ?? "No Email provided")
            TextField("New Email", text: $newEmail)
            
            Button(action: {
                Task{
                    do{
                        try await cortexVM.authManager.updateEmail(email: newEmail)
                        Alert(title: Text("Changed Email succesfully"))
                    }catch{
                        print(error)
                    }
                    
                    self.dismiss()
                }
            }, label: {
                Text("Update Email")
            })
            
        }
        
    }
}

#Preview {
    UpdateEmailView(newEmail: "new@email.com")
}
