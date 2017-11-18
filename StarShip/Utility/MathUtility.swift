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
        }else if(vec.dy == 0){
            if(vec.dx>0){
                return -(.pi*0.5)
            }else{
                return .pi*0.5
            }
        }
        else if(vec.dx == 0){
            if(vec.dy<0){
                return .pi
            }
        }
        return 0.0
    }
    static func getFurthestPoint(target:CGPoint, current:CGPoint, bountry: CGRect)->CGPoint{
        let dy = target.y - current.y
        let dx = target.x - current.x
        let slope = dy/dx
        let c = target.y - (target.x * 1/dx * dy)
    
        if(dx>0 && dy>0){
            let y = slope*bountry.maxX + c
            if(y<bountry.maxY){
                return CGPoint(x:bountry.maxX,y:y)
            }else{
                let x = (bountry.maxY-c)/slope
                return CGPoint(x:x,y:bountry.maxY)
            }
        }else if(dx>0 && dy<0){
            let y = slope*bountry.maxX + c
            if(y>bountry.minY){
                return CGPoint(x:bountry.maxX,y:y)
            }else{
                let x = (bountry.minY-c)/slope
                return CGPoint(x:x,y:bountry.minY)
            }
        }else if(dx<0 && dy>0){
            let y = slope*bountry.minX + c
            if(y<bountry.maxY){
                return CGPoint(x:bountry.minX,y:y)
            }else{
                let x = (bountry.maxY-c)/slope
                return CGPoint(x:x,y:bountry.maxY)
            }
        }else if(dx<0 && dy<0){
            let y = slope*bountry.minX + c
            if(y>bountry.minY){
                return CGPoint(x:bountry.minX,y:y)
            }else{
                let x = (bountry.minY-c)/slope
                return CGPoint(x:x,y:bountry.minY)
            }
        }else if(dx == 0){
            if(dy>0){
                return CGPoint(x: target.x, y: bountry.maxY)
            }else{
                return CGPoint(x: target.x, y: bountry.minY)
            }
           
        }else{
            if(dx>0){
                return CGPoint(x: bountry.maxX, y: target.y)
            }else{
                return CGPoint(x: bountry.minX, y: target.y)
            }
        }
        
    }
    
  
    
}
