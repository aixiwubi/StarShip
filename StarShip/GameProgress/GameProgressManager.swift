//
//  GameProgressManager.swift
//  StarShip
//
//  Created by Wendong Yang on 11/27/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation

class GameProgressManager{
    
    static let sharedInstance = GameProgressManager()
    
    var gameScnes = ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]

    private init(){
        print("Only Instance of GameProgressManager")
    }
    
    public func getProgress()->[String]{
        return gameScnes
    }
}



