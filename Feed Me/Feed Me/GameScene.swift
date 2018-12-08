//
//  GameScene.swift
//  Feed Me
//
//  Created by Brian McCarthy on 16/11/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    
    private var currentLives: Int?
    
    private static var backgroundMusicPlayer: AVAudioPlayer!
    private var sliceSoundAction: SKAction!
    private var splashSoundAction: SKAction!
    private var nomNomSoundAction: SKAction!
    
    private var levelOver = false
    private var vineCut = false
    
    var scoreLabel: SKLabelNode! = SKLabelNode(fontNamed: "Chalkduster")
    var levelLabel: SKLabelNode! = SKLabelNode(fontNamed: "Chalkduster")
    
    private var gameOver = false
    private var curScore = 0 {
        didSet {
            scoreLabel.text = "Score \(curScore)/\(maxScore)"
        }
    }
    private var maxScore = 0 {
        didSet {
            scoreLabel.text = "Score \(curScore)/\(maxScore)"
        }
    }
    
    var mainMenuBtn: SKSpriteNode?
    var playAgainBtn: SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        setupHUD()
        setUpScenery()
        setUpPhysics()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        setUpAudio()
    }
    
    //MARK: - Level setup
    
    fileprivate func setupHUD() {
        if currentLives == nil {
            currentLives = GameConfiguration.maxLives
        }
        
        mainMenuBtn = SKSpriteNode(imageNamed: ImageName.ButtonMenu)
        mainMenuBtn!.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.95)
        mainMenuBtn!.size = mainMenuBtn!.texture!.size()
        addChild(mainMenuBtn!)
        
        for n in 1...GameConfiguration.maxLives {
            let label = SKSpriteNode(imageNamed: ImageName.Heart)
            label.size = CGSize(width: 75, height: 75)
            label.zPosition = 6
            label.position = CGPoint(x: 0 + (label.size.width * CGFloat(n)) + ((n > 1) ? 20 : 0), y: size.height * 0.95)
            
            if currentLives! < GameConfiguration.maxLives && n > currentLives! {
                label.alpha = CGFloat(0.5)
            }
            
            addChild(label)
        }
        
        scoreLabel.text = "Score \(curScore)/\(maxScore)"
        scoreLabel.position = CGPoint(x: size.width * 0.75, y: size.height * 0.90)
        addChild(scoreLabel)
        
        levelLabel.text = "Level \(maxScore + 1)"
        levelLabel.position = CGPoint(x: size.width * 0.75, y: size.height * 0.85)
        addChild(levelLabel)
        
    }
    
    fileprivate func setUpPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
    }
    
    fileprivate func setUpScenery() {
        let background = SKSpriteNode(imageNamed: ImageName.Background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.Background
        background.size = self.size
        addChild(background)
        
        let water = SKSpriteNode(imageNamed: ImageName.Water)
        water.anchorPoint = CGPoint(x: 0, y: 0)
        water.position = CGPoint(x: 0, y: 0)
        water.zPosition = Layer.Water
        water.size = CGSize(width: self.size.width, height: self.size.height * 0.2139)
        addChild(water)
        
    }
    
    fileprivate func setUpPrize() {
        prize = SKSpriteNode(imageNamed: ImageName.Prize)
        prize.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        prize.zPosition = Layer.Prize
        prize.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.Prize), size: prize.size)
        prize.physicsBody?.categoryBitMask = PhysicsCategory.Prize
        prize.physicsBody?.collisionBitMask = 0
        prize.physicsBody?.density = 0.5
        prize.physicsBody?.isDynamic = true
        addChild(prize)
    }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() {
        // 1 load vine data
        var vines: [NSDictionary]?
        if GameConfiguration.level == 0 {
            let dataFile = Bundle.main.path(forResource: GameConfiguration.file, ofType: nil)
            vines = NSArray(contentsOfFile: dataFile!) as! [NSDictionary]
        } else {
            
            let numOfVines: Int = RandomInt(min: 1, max: 4)
            
            vines = [NSDictionary]()
            
            for _ in 2...numOfVines {
                let relAnchorPoint = [
                    String(RandomFloat(min: 0.1, max: 0.9)),
                    String(RandomFloat(min: 0.7, max: 0.9))
                ]
                let anchorPoint = [
                    String(RandomInt(min: 0, max: Int(self.size.width))),
                    String(RandomInt(min: 500, max: Int(self.size.height)))
                ]
                
                let length = RandomInt(min: 15, max: 30)
                vines!.append([
                    "relAnchorPoint" : String("{\(relAnchorPoint.joined(separator:","))}"),
                    "anchorPoint" : String("{\(anchorPoint.joined(separator:","))}"),
                    "length" : length
                    ])
            }
            
        }
        
        // 2 add vines
        for i in 0..<vines!.count {
            // 3 create vine
            let vineData = vines![i]
            let length = Int(vineData["length"] as! NSNumber)
            let relAnchorPoint = CGPointFromString(vineData["relAnchorPoint"] as! String)
            print(relAnchorPoint)
            let anchorPoint = CGPoint(x: relAnchorPoint.x * size.width,
                                      y: relAnchorPoint.y * size.height)
            let vine = VineNode(length: length, anchorPoint: anchorPoint, name: "\(i)")
            
            // 4 add to scene
            vine.addToScene(self)

            // 5 connect the other end of the vine to the prize
            vine.attachToPrize(prize)

        }
    }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() {
        crocodile = SKSpriteNode(imageNamed: ImageName.CrocMouthClosed)
        crocodile.physicsBody = SKPhysicsBody(texture: crocodile.texture!, size: crocodile.size)
        crocodile.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.312)
        crocodile.zPosition = Layer.Crocodile
        crocodile.physicsBody?.categoryBitMask = PhysicsCategory.Crocodile
        crocodile.physicsBody?.collisionBitMask = 0
        crocodile.physicsBody?.contactTestBitMask = PhysicsCategory.Prize
        crocodile.physicsBody?.isDynamic = false
        addChild(crocodile)
        animateCrocodile()
        
    }
    
    fileprivate func animateCrocodile() {
        let durationOpen = drand48() + 2
        let open = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let waitOpen = SKAction.wait(forDuration: durationOpen)
        
        let durationClosed = drand48() + drand48() + 3.0
        
        let close = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let waitClosed = SKAction.wait(forDuration: durationClosed)
        let sequence = SKAction.sequence([waitOpen, open, waitClosed, close])
        let loop = SKAction.repeatForever(sequence)
        crocodile.run(loop)
        
    }
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) {
        crocodile.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        
        maxScore += 1
        curScore += 1
        
        crocodile.run(sequence)
    }
    
    //MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if levelOver || gameOver {
        //    return
        //}
        vineCut = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if nodes(at: touches.first!.location(in: self)).contains(mainMenuBtn!) {
            // load the main menu
            switchToNewScene(SKTransition.doorway(withDuration: 1.0), .Menu)
        }
        
        if levelOver || gameOver {
            if let touch = touches.first {
                let objects = nodes(at: touch.location(in: self))
                if playAgainBtn != nil {
                    if objects.contains(playAgainBtn!) {
                        // restart the game
                        switchToNewScene(SKTransition.doorway(withDuration: 1.0), .Game)
                    }
                }
            }
        } else {
            for touch in touches {
                
                
                    let startPoint = touch.location(in: self)
                    let endPoint = touch.previousLocation(in: self)
                    
                    // check if vine cut
                    scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint,
                                                        using: { (body, point, normal, stop) in
                                                            self.checkIfVineCutWithBody(body)
                    })
                    
                    // produce some nice particles
                    showMoveParticles(touchPosition: startPoint)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) {
        
        if currentLives! < 0 {
            gameOver = true
        }
        
        if gameOver {
            if playAgainBtn == nil {
                
                // https://stackoverflow.com/questions/48039140/how-to-get-all-child-nodes-with-name-in-swift-with-scene-kit
                children.filter({ $0.zPosition == Layer.Crocodile || $0.zPosition == Layer.Prize || $0.zPosition == Layer.Vine }).forEach({ $0.removeFromParent() })
                
                playAgainBtn = SKSpriteNode(imageNamed: ImageName.ButtonRestart)
                playAgainBtn!.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
                playAgainBtn!.size = playAgainBtn!.texture!.size()
                addChild(playAgainBtn!)
                
            }
        }
        
        if levelOver || gameOver {
            return
        }
        
        if prize.position.y <= 0 {
            run(splashSoundAction)
            levelOver = true
            currentLives! -= 1
            GameConfiguration.level += 1
            maxScore += 1
            
            //if GameConfiguration.level >= GameConfiguration.MaxLevels {
            //    GameConfiguration.level = 1
            //}
            
            // switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
            
            if currentLives! >= 0 {
                switchToNewScene(SKTransition.doorway(withDuration: 1.0), .Game)
            } else {
                
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if levelOver {
            return
        }
        
        if (contact.bodyA.node == crocodile && contact.bodyB.node == prize)
            || (contact.bodyA.node == prize && contact.bodyB.node == crocodile) {
            levelOver = true
            // shrink the pineapple away
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([shrink, removeNode])
            prize.run(sequence)
            run(nomNomSoundAction)
            runNomNomAnimationWithDelay(0.15)
            // transition to next level
            // switchToNewGameWithTransition()
            switchToNewScene(SKTransition.doorway(withDuration: 1.0), .Game)
        }
    }
    
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) {
        
        if vineCut && !GameConfiguration.canCutMultipleVinesAtOnce {
            return
        }
        
        let node = body.node!
        
        // if it has a name it must be a vine node
        if let name = node.name {
            // snip the vine
            node.removeFromParent()
            crocodile.removeAllActions()
            crocodile.texture = SKTexture(imageNamed: ImageName.CrocMouthOpen)
            animateCrocodile()
            
            run(sliceSoundAction)
            
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
        }
        
        vineCut = true
    }
    
    enum Scenes {
        case Game, Menu
    }
    
    fileprivate func switchToNewScene(_ transition: SKTransition, _ scenes: Scenes) {
        let delay = SKAction.wait(forDuration: 1)
        let sceneChange = SKAction.run({
            
            switch scenes {
            case .Game:
                let scene = GameScene(size: self.size)
                
                scene.currentLives = (self.currentLives! >= 0) ? self.currentLives! : GameConfiguration.maxLives
                scene.curScore = (self.currentLives! >= 0) ? self.curScore : 0
                scene.maxScore = (self.currentLives! >= 0) ? self.maxScore : 0
                
                self.view?.presentScene(scene, transition: transition)
                break;
            case .Menu:
                self.view?.presentScene(MainMenu(size: self.size), transition: transition)
                break
            }
        })
        
        run(SKAction.sequence([delay, sceneChange]))
    }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() {
        if GameScene.backgroundMusicPlayer == nil {
            let backgroundMusicURL = Bundle.main.url(forResource: SoundFile.BackgroundMusic, withExtension: nil)
            
            do {
                let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
                GameScene.backgroundMusicPlayer = theme
                
            } catch {
                // couldn't load file :[
            }
            
            GameScene.backgroundMusicPlayer.numberOfLoops = -1
        }
        
        if !GameScene.backgroundMusicPlayer.isPlaying && GameConfiguration.playMusic {
            GameScene.backgroundMusicPlayer.play()
        }
        
        sliceSoundAction = SKAction.playSoundFileNamed(SoundFile.Slice, waitForCompletion: false)
        splashSoundAction = SKAction.playSoundFileNamed(SoundFile.Splash, waitForCompletion: false)
        nomNomSoundAction = SKAction.playSoundFileNamed(SoundFile.NomNom, waitForCompletion: false)
    }
}
