//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
//import ScoscheSDK24
//import CoreBluetooth
import SpriteKit
//import AVFoundation


extension SKNode {
    class func blankunarchiveFromFile(_ file : String) -> SKNode? {

        let path =  Bundle.main.path(forResource: file, ofType: "sks")

        let sceneData: Data?
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch _ {
            sceneData = nil
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)

        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! BlankGameScene
        archiver.finishDecoding()
        return scene
    }
}

class BlankGameViewController: UIViewController {

    
//    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = BlankGameScene.blankunarchiveFromFile("BlankGameScene") as? BlankGameScene {
            print("blankview")
            let path = Bundle.main.path(forResource: "BlankGameScene", ofType: "sks")
            print(path)
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
