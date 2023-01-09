//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import ScoscheSDK24
//import CoreBluetooth
import SpriteKit
import AVFoundation


extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        
        let path =  Bundle.main.path(forResource: file, ofType: "sks")

        let sceneData: Data?
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch _ {
            sceneData = nil
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    // setting up mute button
    @IBOutlet var muteButton: UIButton!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
//    // changes mute button when tapped
//    @IBAction func didTapButton() {
//        musictrigger()
//    }

    override var shouldAutorotate : Bool {
        return true
    }
//
//    func musictrigger(){
//        if let player = player, player.isPlaying {
//            //stop playback
//            muteButton.setTitle("Play Music", for: .normal)
//
//            player.stop()
//        } else {
//            //set up player and play
//            muteButton.setTitle("Stop Music", for: .normal)
//            let urlString = Bundle.main.path(forResource: "happyrock", ofType: "mp3")
//            do {
//                try AVAudioSession.sharedInstance().setMode(.default)
//                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//
//                guard let urlString = urlString else {
//                    return
//                }
//
//                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
//
//                guard let player = player else {
//                    return
//                }
//
//                player.play()
//                player.numberOfLoops = -1 // negative int -> loops continuously until stopped
//            } catch {
//                print("music player error")
//            }
//        }
//    }

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
