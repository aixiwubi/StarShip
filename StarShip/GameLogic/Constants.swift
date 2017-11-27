//
//  Constants.swift
//  StarShip
//
//  Created by Wendong Yang on 11/23/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation
import GameKit

struct ConstantValue{
    static let minFloat = Float(0)
    struct Player{
        static let normalSpeed:CGFloat = 15.0
        static let maxHealth:Float = 100.0
    }
    
    struct Enemy{
        static let normalSpeed:CGFloat = 7.5
        static let maxHealth:Float = 30
    }
    
    struct MissileDamage {
        static let basic:Float = 5.0
        static let missile:Float = 15.0
    }
}
