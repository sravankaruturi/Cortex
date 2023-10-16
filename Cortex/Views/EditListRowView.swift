//
//  EditListRowView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 10/15/23.
//

import SwiftUI

struct EditListRowView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    
    @Bindable var todoItem: ItemModel
    
    var body: some View {
        
        ScrollView{
            VStack{
                
                TextField("To Do title", text: $todoItem.title)
                    .padding(.horizontal)
                    .frame(height: 60)
                    .cornerRadius(20)
                    .border(Color.black)
                
                Toggle(isOn: $todoItem.hasReminder){
                    Text("Reminder")
                }
                
                if (todoItem.hasReminder){
                    DatePicker("Due Date", selection: $todoItem.dueDate, displayedComponents: [.date, .hourAndMinute])
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
        .navigationTitle("Edit an item 🖋️")
    }
    
    func saveButtonPressed(){
        if isValidText(){
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func isValidText() -> Bool {
        if todoItem.title.isEmpty {
            return false
        }
        return true
    }
}
