//
//  AddView.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import SwiftUI
import SwiftData

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var cortexViewModel: CortexViewModel
    
    @State private var item: ItemModel = ItemModel()
    
    var body: some View {
        
        ScrollView{
            
            VStack(spacing: 20){
                TextField("Type something here...", text: $item.title)
                    .padding(.horizontal)
                    .frame(height: 60)
                    .background(cortexViewModel.tintColor.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Toggle(isOn: $item.hasReminder){
                    Text("Reminder")
                }
                
                if (item.hasReminder){
                    DatePicker("Due Date", selection: $item.dueDate, displayedComponents: [.date, .hourAndMinute])
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
        .navigationTitle("Add a new item")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func saveButtonPressed(){
        if isValidText(){
            Task{
                await cortexViewModel.saveItem(item)
                cortexViewModel.refreshCurrentUser()
                withAnimation {
                    NotificationManager.instance.scheduleNotifications(item)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func isValidText() -> Bool {
        if item.title.isEmpty {
            return false
        }
        return true
    }
}
