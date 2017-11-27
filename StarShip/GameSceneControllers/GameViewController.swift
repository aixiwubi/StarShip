//
//  GameViewController.swift
//  StarShip
//
//  Created by Wendong Yang on 11/11/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var playerHealth: StatusBar!
    @IBOutlet weak var gameView: SKView!
    
    @IBOutlet weak var score: UILabel!
    var physicsContactDelegate = GameLogic()
    var gameDidEnd:Bool?{
        didSet{
            let gameOverAlert = UIAlertController.init(title: "Game Over", message: "You just Died", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .default){
                action in
                print("clicked ok")
            }
            gameOverAlert.addAction(action)
            present(gameOverAlert, animated: true) {
                print("rip")
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        let scene = GameScene(size: gameView.frame.size)
        physicsContactDelegate.gameScene = scene
        physicsContactDelegate.controller = self
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        scene.physicsWorld.contactDelegate = physicsContactDelegate
        gameView.presentScene(scene)
        gameView.ignoresSiblingOrder = true
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
