//
//  GameLogic.swift
//  StarShip
//
//  Created by Wendong Yang on 11/21/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameLogic:NSObject, SKPhysicsContactDelegate{
    
    weak var gameScene: GameScene?
    weak var controller: GameViewController?
    var percentage: Float?{
        didSet{
            if let controller = controller{
                controller.playerHealth.percentage = percentage
                if percentage == Float(0.0){
                    let finale = SKAction.fadeOut(withDuration: 1)
                    gameScene?.background.run(finale, completion: {
                        self.gameScene?.gameOver()
                        self.controller?.gameDidEnd = true
                    })
                   
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let first = contact.bodyA.node as? MovingObject, let second = contact.bodyB.node as? MovingObject {
            if let missile = first as? Ammuniation, let ship = second as? StarShip{
                missileShipCollision(ship: ship, missile: missile)
                animateExplosion(location: contact.contactPoint, radius: second.size)
            }
            else if let missile = second as? Ammuniation, let ship = first as? StarShip{
                missileShipCollision(ship: ship, missile: missile)
                animateExplosion(location: contact.contactPoint, radius: first.size)
            }
            else if let missile1 = first as? Ammuniation, let missile2 = second as? Ammuniation{
                missileCollision(first: missile1, second: missile2)
                animateExplosion(location: contact.contactPoint, radius: second.size)
            }
            else if let ship1 = first as? StarShip, let ship2 = second as? StarShip{
                shipCollision(first: ship1, second: ship2)
                animateExplosion(location: contact.contactPoint, radius: second.size)
            }
            else if first.role == .buff{
                if let _ = second as? StarShip{
                    first.explode()
                    print("starship got a star")
                }
            }else if second.role == .buff{
                if let _ = first as? StarShip{
                    second.explode()
                    print("starship got a star")
                }
            }
        }
    }
    
    private func missileShipCollision(ship:StarShip,missile:Ammuniation){
        ship.health! -= missile.damage!
        if ship.role == .player{
            updateHealth(ship: ship)
        }
        missile.explode()
    }
    
    private func missileCollision(first:MovingObject,second:MovingObject){
        first.explode()
        second.explode()
    }
    
    private func shipCollision(first:StarShip,second:StarShip){
        print("collide with enemy ship")
        let damage1 = first.health!
        let damage2 = second.health!
        first.health! -= damage2
        second.health! -= damage1
        if first.role == .player{
            updateHealth(ship: first)
        }else{
            updateHealth(ship: second)
        }
    }
    private func updateHealth(ship:StarShip){
        if let health = ship.health{
            if health <= Float(0){
                percentage = Float(0.0)
            }else{
                percentage = health/100.0
            }
        }
        
    }
    
    private func animateExplosion(location:CGPoint, radius:CGSize){
        if let scene = gameScene {
            let square = radius.square()
            let explosion = GameObjectFactory.getMovingObject(imageNamed: "explosion", size: square.divideBy(by: 30), role: .nocontact)
            let expand = SKAction.scale(to: square, duration: 1)
            let shrink = SKAction.scale(to: square.divideBy(by: 30), duration: 1)
            explosion.position = location
            scene.addChild(explosion)
            explosion.run(expand, completion: {
                explosion.run(shrink, completion: {
                    explosion.explode()
                })
            })
        }
    }
}

extension CGSize{
    func square()->CGSize{
        let side = min(self.height,self.width)
        return CGSize(width: side, height: side)
    }
}

