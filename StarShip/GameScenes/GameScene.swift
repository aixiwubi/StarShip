//
//  GameScene.swift
//  StarShip
//
//  Created by Wendong Yang on 11/11/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var inProgress: Bool = false
    var player:StarShip?
    var background:SKSpriteNode = SKSpriteNode(imageNamed: "galaxy")
    var boundry: CGRect?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setUp()
    }
    
    private func setUp(){
       print(self.frame)
    }
    
    override func didMove(to view: SKView){
        player = GameObjectFactory
            .getStarShip(
                role: Identity.player,
                size:self.frame.size.divideBy(by: 15),
                name: "falcon"
        )
        background.zPosition = 0
        background.scale(to: self.frame.size)
        player!.zPosition = 1
        player!.size = CGSize(width: self.frame.width/15, height: self.frame.height/15)
        player!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(background)
        addChild(player!)
        inProgress = true
       
    }
    
    func begin(){
        spawnEnemy()
        spawnBuff()
    }

    func spawnBuff(){
        if let player = player{
            let buff = GameObjectFactory
                .getBuffOrDebuff(
                    imageNamed: "star",
                    size: CGSize(width: player.size.width/2, height: player.size.height/2),
                    role: .buff,
                    buff: BuffType.Health(10.0)
            )
            buff.position = CGPoint(x:self.frame.midX + 100, y:self.frame.midY - 100)
            addChild(buff)
        }
    }
    func gameOver(){
        self.inProgress = false
        self.removeAllActions()
        self.removeAllChildren()
    }

   
    func spawnEnemy(){
        let que = DispatchQueue.global(qos: .default)
        que.async {
            sleep(3)
            if let player = self.player{
                while(self.inProgress){
                    let enemy = GameObjectFactory.getStarShip(role: Identity.minion,size:player.size, name: "enemy")
                    enemy.zPosition = 2
                    let random = (Float(GKRandomSource.sharedRandom().nextInt(upperBound: 100))/100.0)
                    let diff = Float(self.frame.maxX-self.frame.minX)
                    let x = CGFloat(random*diff) + self.frame.minX
                    // print(random)
                    enemy.position = CGPoint(x: x, y: self.frame.maxY)
                    DispatchQueue.main.async {
                         self.addChild(enemy)
                    }
                    let shootQue = DispatchQueue.global(qos: .default)
                    shootQue.async {
                        while(enemy.health!>0){
                            DispatchQueue.main.async {
                                 enemy.shootAt(target: player.position)
                            }
                            sleep(2)
                        }
                    }
                    enemy.move(to: CGPoint(x:x,y:self.frame.minY), completion: {
                        enemy.explode()
                    })
                    sleep(5)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if let player = player{
                player.removeAllActions()
                player.move(to: touch.location(in: self))
                player.shoot()
            }
          //  print("Player at: \(touch.location(in: self))")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
    }
    func testDirection(){
        if let player = player{
            let enemy1 = GameObjectFactory.getStarShip(role: .minion,size:player.size, name: "enemy")
            enemy1.position = CGPoint(x: player.position.x, y: player.position.y+100)
            enemy1.zPosition = 1
            enemy1.zRotation = -.pi/2
            enemy1.size = player.size
            let enemy2 = GameObjectFactory.getStarShip(role: .minion,size:player.size, name: "enemy")
            enemy2.position = CGPoint(x: player.position.x-100, y: player.position.y)
            enemy2.zPosition = 1
            enemy2.zRotation = .pi/2
            enemy2.size = player.size
            let enemy3 = GameObjectFactory.getStarShip(role: .minion,size:player.size, name: "enemy")
            enemy3.position = CGPoint(x: player.position.x+100, y: player.position.y-100)
            enemy3.zPosition = 1
            enemy3.zRotation = -.pi/2
            enemy3.size = player.size
            let enemy4 = GameObjectFactory.getStarShip(role: .minion,size:player.size, name: "enemy")
            enemy4.position = CGPoint(x: player.position.x-100, y: player.position.y-100)
            enemy4.zPosition = 1
            enemy4.zRotation = .pi/2
            enemy4.size = player.size
            addChild(enemy1)
            addChild(enemy2)
            addChild(enemy3)
            addChild(enemy4)
            let shootQue = DispatchQueue.global(qos: .default)
            shootQue.async {
                while(self.inProgress){
                    enemy1.shootAt(target: player.position)
                    enemy2.shootAt(target: player.position)
                    enemy3.shootAt(target: player.position)
                    enemy4.shootAt(target: player.position)
                    sleep(2)
                }
            }
        }
       
    }
}
