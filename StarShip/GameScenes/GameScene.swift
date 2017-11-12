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
    var player:StarShip = StarShip(imageNamed: "falcon")
    var background:SKSpriteNode = SKSpriteNode(imageNamed: "galaxy")
    override func didMove(to view: SKView) {
        background.zPosition = 1
        background.size = self.frame.size
        player.zPosition = 2
        player.size = CGSize(width: self.frame.width/15, height: self.frame.height/15)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(background)
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
        
            player.move(to: touch.location(in: self))
            player.shoot()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
