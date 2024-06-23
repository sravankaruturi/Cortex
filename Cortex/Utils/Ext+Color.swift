//
//  Ext+Color.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/20/24.
//

import Foundation
import SwiftUI

extension Color : RawRepresentable, Codable {
    
    public init?(rawValue: String) {
        
        guard let data = rawValue.data(using: .utf8), let result = try? JSONDecoder().decode(Color.self, from: data) else {
            return nil
        }
        
        self = result
        
    }
    
    
    public var rawValue: String {
        
        guard let data = try? JSONEncoder().encode(self), let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        
        return result
        
    }
    
    
    static let brandPrimary: Color = Color(UIColor(named: "Primary")!)
    
    static let brandPrimaryComponents: [Float] = [0.110, 0.568, 0.006]
    
    func getRGBValues() -> [Float]{
        let comps = UIColor(self).cgColor.components
        
        guard comps != nil else {
            return Color.brandPrimaryComponents
        }
        
        let val = [
            Float(comps![0]),
            Float(comps![1]),
            Float(comps![2])
        ]
        return val
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rgb: [Float] = try container.decode([Float].self)
        self = Color(uiColor: UIColor(red: CGFloat(rgb[0]), green: CGFloat(rgb[1]), blue: CGFloat(rgb[2]), alpha: 1.0))
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        var rgb = self.getRGBValues()
        try container.encode(rgb)
        
    }
    
}
