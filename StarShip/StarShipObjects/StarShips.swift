//
//  StarShips.swift
//  StarShip
//
//  Created by Wendong Yang on 11/11/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation
import SpriteKit

protocol NavigateProtocol{
    func move(to:CGPoint)
    func move(to:CGPoint,completion:@escaping ()->Void)
}

protocol CombatProtocol{
    func shoot()
    func explode()
}

enum Role{
    case player,boss,minion,meterite
}

enum AmmunitionType{
    case missile,bullet,basic
}

class GameObjectFactory{
    static func getStarShip(role:Role,name:String)->StarShip{
        switch role {
        case .player:
            let ship = StarShip(imageNamed: name)
            ship.role = role
            ship.ammoType = AmmunitionType.missile
            ship.health = 100
            return ship
        case .minion:
            let ship = StarShip(imageNamed: name)
            ship.role = role
            ship.ammoType = AmmunitionType.basic
            ship.health = 10
            ship.speed = 15
            return ship
        default:
            return StarShip(imageNamed: name)
        }
    }
    static func getAmmunition(ammoType:AmmunitionType)->Ammuniation{
        switch ammoType {
        case .basic:
            let ammo = Ammuniation(imageNamed: "missile",damage:5)
            ammo.speed = 20
            return ammo
        case .missile:
            return Ammuniation(imageNamed: "missile",damage:10)
        default:
            return Ammuniation(imageNamed: "missile",damage:5)
        }
    }
}


class MovingObject: SKSpriteNode,NavigateProtocol{

    init(imageNamed:String){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: CGSize(width: 1, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(to: CGPoint) {
        let distance = self.position.distance(to: to)
        let action = SKAction.move(to: to, duration:TimeInterval(distance/self.speed))
        self.run(action)
    }
    func move(to: CGPoint, completion: @escaping ()->Void) {
        let distance = self.position.distance(to: to)
        let action = SKAction.move(to: to, duration:TimeInterval(distance/self.speed))
        self.run(action){
            completion()
        }
    }
    func moveWithVector(to:CGPoint, completion: @escaping ()-> Void){
        let vector = CGVector(dx: (to.x-self.position.x)*self.speed, dy: (to.y-self.position.y)*self.speed)
        let action = SKAction.move(by: vector, duration:100)
        self.run(action) {
            completion()
        }
    }
}

class Ammuniation: MovingObject{
    var damage:Int?
    
    convenience init(imageNamed: String, damage: Int) {
        self.init(imageNamed: imageNamed)
        self.damage = damage
    }
    override init(imageNamed: String) {
        super.init(imageNamed: imageNamed)
        self.speed = 25
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StarShip: MovingObject, CombatProtocol{
    
    var role:Role?
    var health: Int?
    var ammoType: AmmunitionType?
    var shield: Int?
    
    override init(imageNamed: String) {
        super.init(imageNamed: imageNamed)
        self.speed = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(){
        if let gameScene = self.parent, let ammoType = ammoType{
            let ammo = GameObjectFactory.getAmmunition(ammoType: ammoType)
            ammo.position = self.position
            ammo.size = CGSize(width: self.size.width/2, height: self.size.height/2)
            ammo.zPosition = self.zPosition
            gameScene.addChild(ammo)
            ammo.move(to: CGPoint(x: ammo.position.x, y: gameScene.frame.maxY), completion: {
                ammo.removeFromParent()
            })
        }
    }
    func shootAt(target:CGPoint){
        if let gameScene = self.parent, let ammoType = ammoType{
            let ammo = GameObjectFactory.getAmmunition(ammoType: ammoType)
            ammo.zRotation = MathUtility.getZrotation(vec: CGVector(dx:target.x-self.position.x,dy:target.y-self.position.y))
            ammo.position = self.position
            ammo.size = CGSize(width: self.size.width/2, height: self.size.height/2)
            ammo.zPosition = self.zPosition
            gameScene.addChild(ammo)
            ammo.move(to: target, completion: {
                ammo.removeFromParent()
            })
        }
    }
    func explode(){
        self.removeAllActions()
        self.removeFromParent()
        self.health = 0
    }
    
}


extension CGFloat{
    var f:Float{
        return Float(self)
    }
}
extension CGPoint{
    func distance(to:CGPoint)->CGFloat{
        let x = self.x-to.x
        let y = self.y-to.y
        return CGFloat(sqrtf(x.f*x.f+y.f*y.f))
    }
}
