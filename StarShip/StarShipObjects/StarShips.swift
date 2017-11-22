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
}

enum Identity:UInt32{
    case nocontact = 0 ,player = 1,minion = 2,buff = 4
    
}

enum AmmunitionType{
    case missile,bullet,basic
}

class GameObjectFactory{
    static func getMovingObject(imageNamed:String,size:CGSize,role: Identity)->MovingObject{
        return MovingObject(imageNamed: imageNamed, size: size, role: role)
    }
    static func getStarShip(role:Identity,size:CGSize,name:String)->StarShip{
        switch role {
        case .player:
            let ship = StarShip(imageNamed: name, size: size, role: role)
            ship.ammoType = AmmunitionType.missile
            ship.health = 100
            ship.speed = 15
            return ship
        case .minion:
            let ship = StarShip(imageNamed: name, size: size, role: role)
            ship.ammoType = AmmunitionType.basic
            ship.health = 30
            ship.speed = 15
            return ship
        default:
            return StarShip(imageNamed: name, size: size, role: .minion)
        }
    }
    static func getAmmunition(ammoType:AmmunitionType, size: CGSize,role:Identity)->Ammuniation{
        switch ammoType {
        case .basic:
            return Ammuniation(imageNamed: "missile",size:size,role:role,damage:5)
        case .missile:
            return Ammuniation(imageNamed: "missile",size:size,role:role,damage:10)
        default:
            return Ammuniation(imageNamed: "missile",size:size,role:role,damage:5)
        }
    }
}


class MovingObject: SKSpriteNode,NavigateProtocol{
    var role:Identity?
    init(imageNamed:String,size:CGSize,role: Identity){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: size)
        self.role = role
        self.zPosition = 1
        let body = SKPhysicsBody(circleOfRadius: max(self.size.height/2,self.size.width/2))
        body.categoryBitMask = role.rawValue
        body.collisionBitMask = 0
        body.affectedByGravity = false
        switch role {
        case .player:
            body.contactTestBitMask = Identity.minion.rawValue & Identity.buff.rawValue
        case .minion:
            body.contactTestBitMask = Identity.player.rawValue
        case .buff:
            body.contactTestBitMask = Identity.player.rawValue
        default:
            body.contactTestBitMask = role.rawValue
        }
        self.physicsBody = body
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
    func explode(){
        self.removeAllActions()
        self.removeFromParent()
    }
}

class Ammuniation: MovingObject{
    var damage:Int?
    
    convenience init(imageNamed: String, size: CGSize, role: Identity,damage:Int){
        self.init(imageNamed: imageNamed, size:size, role: role)
        self.damage = damage
    }
    override init(imageNamed: String, size: CGSize, role: Identity) {
        super.init(imageNamed: imageNamed, size: size, role: role)
        self.speed = 18
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StarShip: MovingObject, CombatProtocol{
    
    var health: Int?{
        didSet{
            if self.health! < 0{
                self.explode()
            }
        }
    }
    var ammoType: AmmunitionType?
    var shield: Int?
    
    override init(imageNamed: String,size:CGSize, role:Identity) {
        super.init(imageNamed: imageNamed,size: size,role: role)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(){
        if let gameScene = self.parent, let ammoType = ammoType,let role = self.role{
            let ammo = GameObjectFactory.getAmmunition(ammoType: ammoType,size: self.size.divideBy(by: 2),role: role)
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
        if let gameScene = self.parent, let ammoType = ammoType, let role = self.role{
            let ammo = GameObjectFactory.getAmmunition(ammoType: ammoType,size: self.size.divideBy(by: 2),role: role)
            ammo.zRotation = MathUtility.getZrotation(vec: CGVector(dx:target.x-self.position.x,dy:target.y-self.position.y))
            ammo.position = self.position
            ammo.size = CGSize(width: self.size.width/2, height: self.size.height/2)
            gameScene.addChild(ammo)
            let maxLocation = MathUtility.getFurthestPoint(target: target, current: self.position, bountry: gameScene.frame)
            ammo.move(to: maxLocation, completion: {
                    ammo.explode()
            })
        }
    }

}

extension CGSize{
    func divideBy(by:CGFloat)->CGSize{
        return CGSize(width: self.width/by, height: self.height/by)
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
