//
//  AddView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFieldText: String = ""
    
    var body: some View {
        
        ScrollView{
            
            VStack{
                TextField("Type something here...", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(20)
                
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
            }
            .padding(15)
            
        }
        .navigationTitle("Add an Item 🖋️")
        
    }
    
    func saveButtonPressed(){
        listViewModel.addItem(title: textFieldText)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView{
        AddView()
    }.environmentObject(ListViewModel())
}
