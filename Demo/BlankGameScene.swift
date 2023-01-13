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
    var maxreading: Int = 145
    
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
    
    func drawcircle(){
        
        // draw clock circle
        let circle = SKShapeNode(circleOfRadius: 30)
            circle.fillColor = skyColor
            circle.strokeColor = SKColor.clear
            circle.zRotation = CGFloat.pi / 2
            circle.setScale(5.0)
            circle.position = CGPoint( x: self.frame.midX, y: self.frame.midY )
            addChild(circle)

            countdown(circle: circle, steps: 60, duration: 60) {}

    }
    
    // Creates an animated countdown timer
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, completion:@escaping ()->Void) {
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = CGFloat(1.0)

        let animate = SKAction.run {
            percent -= incr
            circle.path = self.circle(radius: radius, percent:percent)
        }
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])

        run(SKAction.repeat(action,count:steps-1)) {
            self.run(SKAction.wait(forDuration:timeInterval)) {
                circle.path = nil
                completion()
            }
        }
    }

    // Creates a CGPath in the shape of a pie with slices missing
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
        let start:CGFloat = 0
        let end = CGFloat.pi * 2 * percent
        let center = CGPoint.zero
        let bezierPath = UIBezierPath()
        bezierPath.move(to:center)
        bezierPath.addArc(withCenter:center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        bezierPath.addLine(to:center)
        return bezierPath.cgPath
    }

    
//    @objc func updateCounter() {
//        //example functionality
//        if counter > 0 {
//   //         print("\(counter) seconds to the end of the world")
//            counter -= 1
//        }
//    }
    
//
//    func spawnPipes() {
//        let pipePair = SKNode()
//        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
//        pipePair.zPosition = -10
//
//        let height = UInt32( self.frame.size.height / 4)
//        let y = Double(arc4random_uniform(height) + height)
//
//        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
//        pipeDown.setScale(2.0)
//        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
//
//
//        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
//        pipeDown.physicsBody?.isDynamic = false
//        pipeDown.physicsBody?.categoryBitMask = pipeCategory
//        pipeDown.physicsBody?.contactTestBitMask = birdCategory
//        pipePair.addChild(pipeDown)
//
//        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
//        pipeUp.setScale(2.0)
//        pipeUp.position = CGPoint(x: 0.0, y: y)
//
//        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
//        pipeUp.physicsBody?.isDynamic = false
//        pipeUp.physicsBody?.categoryBitMask = pipeCategory
//        pipeUp.physicsBody?.contactTestBitMask = birdCategory
//        pipePair.addChild(pipeUp)
//
//        let contactNode = SKNode()
//        contactNode.position = CGPoint( x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY )
//        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
//        contactNode.physicsBody?.isDynamic = false
//        contactNode.physicsBody?.categoryBitMask = scoreCategory
//        contactNode.physicsBody?.contactTestBitMask = birdCategory
//        pipePair.addChild(contactNode)
//
//        pipePair.run(movePipesAndRemove)
//        pipes.addChild(pipePair)
//
//    }
//
//    func resetScene (){
//        // Move bird to original position and reset velocity
//        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
//        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
//        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
//        bird.speed = 1.0
//        bird.zRotation = 0.0
//
//        // Move blackbird to original position and reset velocity
//        blackbird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
//        blackbird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
//        blackbird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
//        blackbird.speed = 1.0
//        blackbird.zRotation = 0.0
//
//        // Remove all existing pipes
//        pipes.removeAllChildren()
//
//        // Reset _canRestart
//        canRestart = false
//
//        // Reset score
//        score = 0
//        scoreLabelNode.text = String(score)
//
//        // Restart animation
//        moving.speed = 1
//    }
    
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if moving.speed > 0  {
////            for _ in touches { // do we need all touches?
////                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
////                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
////            }
//        }
////        else if canRestart {
////            self.resetScene()
////        }
//    }
    
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
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            canRestart = false
            // allow touch again
            
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
    
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    func musicstop(){
        if let player = player, player.isPlaying {
            //stop playback
//            muteButton.setTitle("Play Music", for: .normal)
            
            player.stop()
            playing = false
        }
    }
    
    func musicstart(){
        
        //set up player and play
//            muteButton.setTitle("Stop Music", for: .normal)
        playing = true
        let urlString = Bundle.main.path(forResource: "happyrock", ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            
            guard let player = player else {
                return
            }
            
            player.play()
            player.numberOfLoops = -1 // negative int -> loops continuously until stopped
        } catch {
            print("music player error")
        }
    }
}
