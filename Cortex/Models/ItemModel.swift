//
//  ItemModel.swift
//  Cortex
//
//  Created by Sravan Karuturi on 9/25/23.
//

import Foundation

struct ItemModel: Identifiable{
    
    // We're using strings here because they're a little bit easier to work with when we try to integrate with 3rd party databases
    let id: String = UUID().uuidString
    let title: String
    let isCompleted: Bool
    
}
