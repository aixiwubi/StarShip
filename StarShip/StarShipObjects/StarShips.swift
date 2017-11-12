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
enum ModelType{
    case op
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
    
    func move(to:CGPoint, completion: @escaping ()-> Void){
        let distance = self.position.distance(to: to)
        let action = SKAction.move(to: to, duration:TimeInterval(distance/self.speed))
        self.run(action) {
            completion()
        }
    }
}

class Ammuniation: MovingObject{
    override init(imageNamed: String) {
        super.init(imageNamed: imageNamed)
        self.speed = 30
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StarShip: MovingObject, CombatProtocol{
    
    var role:Role?
    var model: ModelType?
    var health: Int?
    var damage: Int?
    var shield: Int?
    
    override init(imageNamed: String) {
        super.init(imageNamed: imageNamed)
        self.speed = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(){
        if let gameScene = self.parent{
            let missile = Ammuniation(imageNamed: "missile")
            missile.position = self.position
            missile.size = CGSize(width: self.size.width/2, height: self.size.height/2)
            missile.zPosition = self.zPosition
            gameScene.addChild(missile)
            missile.move(to: CGPoint(x: missile.position.x, y: gameScene.frame.maxY), completion: {
                missile.removeFromParent()
            })
        }
    }
    func explode(){
        self.removeAllActions()
        self.removeFromParent()
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
