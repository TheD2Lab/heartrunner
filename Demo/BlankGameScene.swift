//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit
import AVFoundation


class BlankGameScene: SKScene, SKPhysicsContactDelegate{
//    let verticalPipeGap = 150.0
    
    
    var bird:SKSpriteNode!
//    var blackbird:SKSpriteNode!
    var staticbird:SKSpriteNode!
//    var staticblackbird:SKSpriteNode!
    let skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    let skyZoneOneColor = SKColor(red: 56.0/255.0, green: 61/255.0, blue: 63/255.0, alpha: 1.0)
    let skyZoneTwoColor = SKColor(red: 14/255.0, green: 124/255.0, blue: 158/255.0, alpha: 1.0)
    let skyZoneThreeColor = SKColor(red: 85.0/255.0, green: 163/255.0, blue: 34/255.0, alpha: 1.0)
    let skyZoneFourColor = SKColor(red: 186/255.0, green: 138/255.0, blue: 5/255.0, alpha: 1.0)
    let skyZoneFiveColor = SKColor(red: 178/255.0, green: 12/255.0, blue: 73/255.0, alpha: 1.0)
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var birdheartrate:SKLabelNode!
//    var blackbirdheartrate:SKLabelNode!
    var score = NSInteger()
    var counter = NSInteger()
    let starttime = Date()
    var maxreading: Int = 0
    
//    var runtime = NSInteger()
    var runtime = 20
    
    var player: AVAudioPlayer?
    var playing = false
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override func didMove(to view: SKView) {
        
        //being init
        canRestart = true
        //disable touch
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.backgroundColor = SKColor(white: 1, alpha: 1)
        
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        
        
        /* Called before each frame is rendered */
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: starttime, to: Date())
        score = runtime - Int(interval.minute!)

        
        if (score < 1){
//            only run once
            if (canRestart == true ){
                let scoreBoardTexture = SKSpriteNode(imageNamed: "scoreboard")
                scoreBoardTexture.setScale(1.5)
                scoreBoardTexture.position = CGPoint(x: self.frame.size.width/2, y:self.frame.size.height/2)
                scoreBoardTexture.zPosition = 120
                self.addChild(scoreBoardTexture)
                
                let scoreMaxNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
                scoreMaxNode.position = CGPoint(x: self.frame.size.width/2, y:((self.frame.size.height/2) - 50))
                scoreMaxNode.zPosition = 121
                scoreMaxNode.fontColor = SKColor.black
                scoreMaxNode.text = String(maxreading)
                
                self.addChild(scoreMaxNode)
                // allow touch again
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            canRestart = false
            
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if moving.speed > 0 && score > 0 {
//            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score -= 1
                scoreLabelNode.text = String(score)
                
                // Add a little visual feedback for the score increment
                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            } else {
                
                moving.speed = 0
                
                bird.physicsBody?.collisionBitMask = worldCategory
                bird.run(  SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                
                
                // Flash background if contact is detected
                self.removeAction(forKey: "flash")
                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                    }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                        self.backgroundColor = self.skyZoneOneColor
                        }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                            self.canRestart = true
                            })]), withKey: "flash")
            }
        }
    }
}
