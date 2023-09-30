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
    @State var date = Date()
    @State var hasDueDate: Bool = false
    
    var body: some View {
        
        ScrollView{
            
            VStack{
                TextField("Type something here...", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(20)
                
                Toggle(isOn: $hasDueDate){
                    Text("Reminder")
                }
                
                if ( hasDueDate){
                    DatePicker("Due Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
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
        if isValidText(){
            listViewModel.addItem(title: textFieldText, hasReminder: hasDueDate, dueDate: date)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func isValidText() -> Bool {
        if textFieldText.isEmpty {
            return false
        }
        return true
    }
}

#Preview {
    NavigationView{
        AddView()
    }.environmentObject(ListViewModel())
}
