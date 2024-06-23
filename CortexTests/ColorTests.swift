//
//  ColorTests.swift
//  CortexTests
//
//  Created by Sravan Karuturi on 6/22/24.
//

import Foundation
import Testing
import SwiftUI

@testable import Cortex


struct ColorTests {
    
    @Test func ColorHasRawValue() {
        
        let col = Color(.white)
        #expect(col.rawValue != "[]")
        
    }
    
    @Test("Color Return RGB Values")
    func ColorReturnsRGBValues() {
        
        let col = Color(.white)
        let rgbValues = col.getRGBValues()
        #expect( abs(rgbValues[0] - 1.0 ) < Float.ulpOfOne )
        #expect( abs(rgbValues[1] - 1.0 ) < Float.ulpOfOne )
        #expect( abs(rgbValues[2] - 1.0 ) < Float.ulpOfOne )
        
    }
    
}
