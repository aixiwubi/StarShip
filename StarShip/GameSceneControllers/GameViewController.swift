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
    
    var physicsContactDelegate = GameLogic()
    var gameDidEnd:Bool?{
        didSet{
            let gameOverAlert = UIAlertController.init(title: "Game Over", message: "You just Died", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: .default) { action in
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
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            physicsContactDelegate.gameScene = scene
            physicsContactDelegate.controller = self
            print(view.frame.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFill
            scene.physicsWorld.contactDelegate = physicsContactDelegate
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
