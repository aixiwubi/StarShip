//
//  GameScene.swift
//  StarShip
//
//  Created by Wendong Yang on 11/11/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var inProgress: Bool = false
    var player = GameObjectFactory.getStarShip(role: Role.player, name: "falcon")
    var background:SKSpriteNode = SKSpriteNode(imageNamed: "galaxy")
    override func didMove(to view: SKView) {
        background.zPosition = 1
        background.size = self.frame.size
        player.zPosition = 2
        player.size = CGSize(width: self.frame.width/15, height: self.frame.height/15)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(background)
        addChild(player)
        inProgress = true
        spawnEnemy()
        //testDirection()
    }
   
    func spawnEnemy(){
        let que = DispatchQueue.global(qos: .default)
        que.async {
            while(self.inProgress){
                let enemy = GameObjectFactory.getStarShip(role: Role.minion, name: "enemy")
                enemy.size = self.player.size
                enemy.zPosition = 2
                let random = (Float(GKRandomSource.sharedRandom().nextInt(upperBound: 100))/100.0)
                let diff = Float(self.frame.maxX-self.frame.minX)
                let x = CGFloat(random*diff) + self.frame.minX
               // print(random)
                enemy.position = CGPoint(x: x, y: self.frame.maxY)
                self.addChild(enemy)
                let shootQue = DispatchQueue.global(qos: .default)
                shootQue.async {
                    while(enemy.health!>0){
                        enemy.shootAt(target: self.player.position)
                        sleep(2)
                    }
                }
                enemy.shootAt(target: self.player.position)
                enemy.move(to: CGPoint(x:x,y:self.frame.minY), completion: {
                    enemy.explode()
                })
   
                sleep(5)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            player.move(to: touch.location(in: self))
            player.shoot()
            print("Player at: \(touch.location(in: self))")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func testDirection(){
        let enemy1 = GameObjectFactory.getStarShip(role: .minion, name: "enemy")
        enemy1.position = CGPoint(x: player.position.x+100, y: player.position.y+100)
        enemy1.zPosition = 2
        enemy1.zRotation = -.pi/2
        enemy1.size = player.size
        let enemy2 = GameObjectFactory.getStarShip(role: .minion, name: "enemy")
        enemy2.position = CGPoint(x: player.position.x-100, y: player.position.y+100)
        enemy2.zPosition = 2
        enemy2.zRotation = .pi/2
        enemy2.size = player.size
        let enemy3 = GameObjectFactory.getStarShip(role: .minion, name: "enemy")
        enemy3.position = CGPoint(x: player.position.x+100, y: player.position.y-100)
        enemy3.zPosition = 2
        enemy3.zRotation = -.pi/2
        enemy3.size = player.size
        let enemy4 = GameObjectFactory.getStarShip(role: .minion, name: "enemy")
        enemy4.position = CGPoint(x: player.position.x-100, y: player.position.y-100)
        enemy4.zPosition = 2
        enemy4.zRotation = .pi/2
        enemy4.size = player.size
        addChild(enemy1)
        addChild(enemy2)
        addChild(enemy3)
        addChild(enemy4)
        let que = DispatchQueue.global(qos: .default)
        que.async {
            while(self.inProgress){
                enemy1.shootAt(target: self.player.position)
                enemy2.shootAt(target: self.player.position)
                enemy3.shootAt(target: self.player.position)
                enemy4.shootAt(target: self.player.position)
                sleep(1)
            }
        }
    }
}
