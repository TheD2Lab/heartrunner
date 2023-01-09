//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var bird:SKSpriteNode!
    var staticbird:SKSpriteNode!
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
    var score = NSInteger()
    var counter = NSInteger()
    let starttime = Date()
    var maxreading: Int = 0
    
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
        
        //give time the file to finish writting
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (timer) in
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
        
        
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        self.backgroundColor = skyZoneOneColor
        
        moving = SKNode()
        self.addChild(moving)
        
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
        

        let fileURL = getDocumentsDirectory().appendingPathComponent("avatar.png")
        let data = try! Data.init(contentsOf: fileURL)
        let photo = UIImage.init(data: data)
        let avatar = SKTexture(image: photo!)
        
        
        bird = SKSpriteNode(texture: avatar)
        bird.setScale(1.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.25, y:self.frame.size.height * 0.5)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
        //set heart rate board
        
        let scoreBoardTexture = SKSpriteNode(imageNamed: "land")
        scoreBoardTexture.setScale(1.5)
        scoreBoardTexture.position = CGPoint(x: self.frame.size.width * 0.50, y:self.frame.size.height * 0.95)
        self.addChild(scoreBoardTexture)
        
        staticbird =  SKSpriteNode(texture: avatar)
        staticbird.setScale(1.0)
        staticbird.zPosition = 100
        staticbird.position = CGPoint(x: self.frame.size.width * 0.30, y:self.frame.size.height * 0.92)
        self.addChild(staticbird)
        
        
        score = 70
        birdheartrate = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        birdheartrate.position = CGPoint(x: self.frame.size.width * 0.50, y:self.frame.size.height * 0.9)
        birdheartrate.zPosition = 100
        birdheartrate.fontColor = SKColor.black
        birdheartrate.text = String(score)
        self.addChild(birdheartrate)

        
        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        
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
                
                // getting max reading for the end
                if (reading > maxreading) {maxreading = reading}
                
                var tempreading = Double(reading)
                tempreading = tempreading - 70 //assuming base is 70 bps
                if (tempreading > 100) {tempreading = 100}
                if (tempreading < 0) {tempreading = 0}
                //assume 170 as max heart rate
                //170 is at height * 0.85
                // 70 is at height * 0.35
                // from 0.65 is range from 100 ,0.0065 pixel per bps

                let heartrateposition = (0.0065*tempreading) + 0.25

                bird.position = CGPoint(x: self.frame.size.width * heartrateposition, y:self.frame.size.height * 0.5)
                
                
                //update heart rate score
                birdheartrate.text = String(temp)
                
                // triggers based on heartrate
                if reading < 80 {
                    moving.speed = 1
                    self.backgroundColor = skyZoneOneColor
                }
                if reading > 80 && reading < 90{
                    if playing == true{
                        musicstop()
                    }
                    moving.speed = 1.25
                    self.backgroundColor = skyZoneOneColor
                }
                if reading > 90 && reading < 100{
                    if playing == false{
                        musicstart()
                    }
                    moving.speed = 1.5
                    self.backgroundColor = skyZoneTwoColor
                }
                if reading > 100 && reading < 110{
                    moving.speed = 2
                    self.backgroundColor = skyZoneThreeColor
                }
                if reading > 110 && reading < 120{
                    moving.speed = 3
                    self.backgroundColor = skyZoneFourColor
                }
                if reading > 120 && reading < 130{
                    moving.speed = 4
                    self.backgroundColor = skyZoneFiveColor
                }
            }
            catch {/* error handling here */}
        }
        
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
            
            player.stop()
            playing = false
        }
    }
    
    func musicstart(){
        
        //set up player and play
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
