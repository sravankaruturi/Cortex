//
//  Ext+Color.swift
//  Cortex
//
//  Created by Sravan Karuturi on 5/20/24.
//

import Foundation
import SwiftUI

extension Color {
    
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
    
}
