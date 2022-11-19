//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit
//import SwiftUI


class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var blackbird:SKSpriteNode!
    var staticbird:SKSpriteNode!
    var staticblackbird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var birdheartrate:SKLabelNode!
    var blackbirdheartrate:SKLabelNode!
    var score = NSInteger()
    var counter = NSInteger()
    let starttime = Date()
    
//    var runtime = NSInteger()
    var runtime = 20
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override func didMove(to view: SKView) {
        
        canRestart = true
        
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
//        pipes = SKNode()
//        moving.addChild(pipes)
        
        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for i in 0 ..< 2 + Int(self.frame.size.width / ( groundTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest
        
        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for i in 0 ..< 2 + Int(self.frame.size.width / ( skyTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }
        
        // create the pipes textures
//        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
//        pipeTextureUp.filteringMode = .nearest
//        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
//        pipeTextureDown.filteringMode = .nearest
        
        // create the pipes movement actions
//        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
//        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
//        let removePipes = SKAction.removeFromParent()
//        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
//
        // spawn the pipes
//        let spawn = SKAction.run(spawnPipes)
//        let delay = SKAction.wait(forDuration: TimeInterval(2.0))
//        let spawnThenDelay = SKAction.sequence([spawn, delay])
//        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
//        self.run(spawnThenDelayForever)
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .nearest
        let birdTexture3 = SKTexture(imageNamed: "bird-03")
        birdTexture3.filteringMode = .nearest
        let birdTexture4 = SKTexture(imageNamed: "bird-04")
        birdTexture4.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [birdTexture1, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.25, y:self.frame.size.height * 0.65)
        bird.run(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
        
        // setup our black bird
        let blackbirdTexture1 = SKTexture(imageNamed: "bird-a")
        blackbirdTexture1.filteringMode = .nearest
        let blackbirdTexture2 = SKTexture(imageNamed: "bird-b")
        blackbirdTexture2.filteringMode = .nearest
        let blackbirdTexture3 = SKTexture(imageNamed: "bird-c")
        blackbirdTexture3.filteringMode = .nearest
        let blackbirdTexture4 = SKTexture(imageNamed: "bird-d")
        blackbirdTexture4.filteringMode = .nearest
        
        let anim2 = SKAction.animate(with: [blackbirdTexture1, blackbirdTexture2, blackbirdTexture3, blackbirdTexture4], timePerFrame: 0.2)
        let flap2 = SKAction.repeatForever(anim2)
        
        blackbird = SKSpriteNode(texture: blackbirdTexture1)
        blackbird.setScale(2.0)
        blackbird.position = CGPoint(x: self.frame.size.width * 0.25, y:self.frame.size.height * 0.5)
        blackbird.run(flap2)
        
        
        blackbird.physicsBody = SKPhysicsBody(circleOfRadius: blackbird.size.height / 2.0)
        blackbird.physicsBody?.isDynamic = true
        blackbird.physicsBody?.allowsRotation = false
        
        blackbird.physicsBody?.categoryBitMask = birdCategory
        blackbird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        blackbird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(blackbird)
        
        
        
        //set heart rate board
        
        let scoreBoardTexture = SKSpriteNode(imageNamed: "land")
        scoreBoardTexture.setScale(1.5)
        scoreBoardTexture.position = CGPoint(x: self.frame.size.width * 0.50, y:self.frame.size.height * 0.95)
        self.addChild(scoreBoardTexture)
        
        staticbird =  SKSpriteNode(texture: birdTexture1)
        staticbird.setScale(2.0)
        staticbird.zPosition = 100
        staticbird.position = CGPoint(x: self.frame.size.width * 0.30, y:self.frame.size.height * 0.92)
        self.addChild(staticbird)
        
        
        score = 70
        birdheartrate = SKLabelNode(fontNamed:"MarkerFelt-Wide")
//        birdheartrate.color = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        birdheartrate.position = CGPoint(x: self.frame.size.width * 0.40, y:self.frame.size.height * 0.9)
        birdheartrate.zPosition = 100
        birdheartrate.fontColor = SKColor.black
        birdheartrate.text = String(score)
        self.addChild(birdheartrate)
        
        staticblackbird =  SKSpriteNode(texture: blackbirdTexture1)
        staticblackbird.setScale(2.0)
        staticblackbird.zPosition = 100
        staticblackbird.position = CGPoint(x: self.frame.size.width * 0.6, y:self.frame.size.height * 0.92)
        self.addChild(staticblackbird)
        
        
        score = 70
        blackbirdheartrate = SKLabelNode(fontNamed:"MarkerFelt-Wide")
//        blackbirdheartrate.color = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        blackbirdheartrate.position = CGPoint(x: self.frame.size.width * 0.7, y:self.frame.size.height * 0.9)
        blackbirdheartrate.zPosition = 100
        blackbirdheartrate.fontColor = SKColor.black
        blackbirdheartrate.text = String(score)
        self.addChild(blackbirdheartrate)
        
        
        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        //give time the file to finish writting
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            let file = "runtime.txt"
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(file)
                
                //reading
                do {
                    let temp = try String(contentsOf: fileURL, encoding: .utf8)
    //                print (temp)
                    self.runtime = Int(temp)!
                    print(self.runtime)
                }
                catch {/* error handling here */}
            }
        }
        
        
        // Initialize label and create a label which holds the score // turn this into the minute counter
//
        // draw clock circle
        drawcircle()

        
        // Initialize label and create a label which holds the score // turn this into the minute counter
        score = runtime
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.fontColor = SKColor.black
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
        
    }
    
    func drawcircle(){
        
        // draw clock circle
        let circle = SKShapeNode(circleOfRadius: 30)
            circle.fillColor = SKColor.yellow
            circle.strokeColor = SKColor.clear
            circle.zRotation = CGFloat.pi / 2
            circle.position = CGPoint( x: self.frame.midX, y: (3 * self.frame.size.height / 4)+10 )
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

    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
//            print("\(counter) seconds to the end of the world")
            counter -= 1
        }
    }
    
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
        if(Int(interval.second!) == 0) {drawcircle()}
        score = runtime - Int(interval.minute!)
        scoreLabelNode.text = String(score)
        
        var reading = 0
        let file = "reading.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            do {
                let temp = try String(contentsOf: fileURL, encoding: .utf8)
                reading = Int(temp)!
                var tempreading = Double(reading)
                tempreading = tempreading - 70 //assuming base is 70 bps
                if (tempreading > 100) {tempreading = 100}
                if (tempreading < 0) {tempreading = 0}
                //assume 170 as max heart rate
                //170 is at height * 0.85
                // 70 is at height * 0.35
                // from 0.65 is range from 100 ,0.0065 pixel per bps

                let heartrateposition = (0.0065*tempreading) + 0.25

                bird.position = CGPoint(x: self.frame.size.width * heartrateposition, y:self.frame.size.height * 0.65)
                
                //get the reading of the other device on cloud and use that reading for the heart rate postion calculator
//                let temp = try String(contentsOf: fileURL, encoding: .utf8)
//                reading = Int(temp)!
//                var tempreading = Double(reading)
//                tempreading = tempreading - 70
//                print(tempreading)
                //170 as max heart rate
                //170 is at height * 0.85
                // 70 is at height * 0.35
                // from 0.5 is range from 100 , 0.1 for every 20 bit, 100/0.5
//                let heartrateposition = (0.005*tempreading) + 0.35
                blackbird.position = CGPoint(x: self.frame.size.width * heartrateposition, y:self.frame.size.height * 0.5)
                
                
                //update heart rate score
                birdheartrate.text = String(temp)
                blackbirdheartrate.text = String(temp)
            }
            catch {/* error handling here */}
        }
        
        if (score < 1){
            let scoreBoardTexture = SKSpriteNode(imageNamed: "scoreboard")
            scoreBoardTexture.setScale(1.5)
            scoreBoardTexture.position = CGPoint(x: self.frame.size.width/2, y:self.frame.size.height/2)
            self.addChild(scoreBoardTexture)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if moving.speed > 0 && score > 0 {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

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
                        self.backgroundColor = self.skyColor
                        }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                            self.canRestart = true
                            })]), withKey: "flash")
            }
        }
    }
}
