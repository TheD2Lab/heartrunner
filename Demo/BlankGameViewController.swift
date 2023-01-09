//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class BlankGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("BlankGameScene") as? BlankGameScene {
            let path = Bundle.main.path(forResource: "BlankGameScene", ofType: "sks")
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
            
        }
    }
        
        
        override var shouldAutorotate : Bool {
            return true
        }
        
        override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return UIInterfaceOrientationMask.allButUpsideDown
            } else {
                return UIInterfaceOrientationMask.all
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
        
    
}
