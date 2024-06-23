//
//  DBAccountInfo.swift
//  Cortex
//
//  Created by Sravan Karuturi on 6/2/24.
//

import Foundation
import SwiftUI

struct DBAccountInfo : Codable {
    
    let userId: String
    let email: String?
    let dateCreated: Date?
    var accentColor: Color
    var items: [ItemModel]
    
    enum CodingKeys : String, CodingKey {
        
        case userId = "user_id"
        case email = "email"
        case dateCreated = "date_created"
        case accentColor = "accent_color"
        case items = "items"
        
    }
    
    init(userId: String, email: String? , dateCreated: Date?, accentColor: Color, items: [ItemModel] ){
        self.userId = userId
        self.email = email
        self.dateCreated = dateCreated
        self.accentColor = accentColor
        self.items = items
    }
    
    init(from decoder: Decoder) throws {
        let values  =   try decoder.container(keyedBy: CodingKeys.self)
        userId      =   try values.decode(String.self, forKey: .userId)
        email       =   try values.decodeIfPresent(String.self, forKey: .email)
        dateCreated =   try values.decodeIfPresent(Date.self, forKey: .dateCreated)
        items       =   try values.decodeIfPresent([ItemModel].self, forKey: .items) ?? []
        
        let colorComponents =   try values.decodeIfPresent([Float].self, forKey: .accentColor) ?? nil
        var tintColor = Color.brandPrimary
        if ( colorComponents != nil ){
            tintColor = Color(uiColor: UIColor(
                red: CGFloat(colorComponents![0]),
                green: CGFloat(colorComponents![1]),
                blue: CGFloat(colorComponents![2]),
                alpha: 1.0
            ))
        }
        self.accentColor = tintColor
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.items, forKey: .items)
        
        // Get the color components to encode color. Use NSColor for MACOs
        let colorComponents = self.accentColor.getRGBValues()
        try container.encode(
            colorComponents,
            forKey: .accentColor)
        
        
    }
    
}
