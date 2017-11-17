//
//  MathUtility.swift
//  StarShip
//
//  Created by Wendong Yang on 11/12/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//
import Foundation
import GameKit

class MathUtility{
    static func degreesToRadians(degrees: CGFloat) -> CGFloat { return degrees * .pi / 180.0 }
    static func radiansToDegrees(radians: CGFloat) -> CGFloat { return radians * 180.0 / .pi }
    
    static func getVectorDirection(vec:CGVector)->CGFloat{
        return atan2(vec.dy, vec.dx)
    }
    static func getZrotation(vec:CGVector)->CGFloat{
        let direction = atan2(vec.dy, vec.dx)
        if(vec.dx>0 && vec.dy>0){
            return -(.pi/2-direction)
        }else if(vec.dx>0 && vec.dy<0){
            return -(.pi/2) + direction
        }else if(vec.dx<0 && vec.dy>0){
            return (.pi*1.5) + direction
        }else if(vec.dx<0 && vec.dy<0){
            return direction - .pi/2
        }
        return 0.0
    }
    
  
    
}
