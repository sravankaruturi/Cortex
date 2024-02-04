//
//  PomoViewModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 10/16/23.
//

import Foundation

extension PomoView {
    
    final class PomoViewModel : ObservableObject {
        
        private var initialTime = 25
        private var endDate = Date()
        
        @Published var isActive = false
        @Published var time: String = "25:00"
        @Published var minutes: Float = 25.00 {
            didSet{
                self.time = "\(Int(minutes)):00"
            }
        }
        
        private var seconds: Float = 0.0
        
        var percentageDone: Float {
            if !isActive {
                return 1.0
            }
            
            let totalTime: Float = Float(initialTime) * 60
            let remainingTime: Float = Float(minutes) * 60 + seconds
            let perc = remainingTime / totalTime
            
            return perc
        }
        
        func start(minutes: Float = 25.0){
            self.initialTime = Int(minutes)
            self.endDate = Calendar.current.date(byAdding: .minute, value: self.initialTime, to: .now)!
            
            self.isActive = true
        }
        
        func reset(){
            self.minutes = Float(initialTime)
            self.isActive = false
        }
        
        func updateCountDown(){
            
            guard isActive else {
                return
            }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                self.time = "00:00"
                
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.minutes = Float(minutes)
            self.seconds = Float(seconds)
            self.time = String(format: "%02d:%02d", minutes, seconds)
            
        }
        
    }
    
}
