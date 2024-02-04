//
//  MainMenuOptions.swift
//  Cortex
//
//  Created by Sravan Karuturi on 10/15/23.
//

import Foundation

enum MainMenuOptions : String, Identifiable, CaseIterable{
    
    case todo, pomo
    
    var id: String { return self.rawValue }
    
}
