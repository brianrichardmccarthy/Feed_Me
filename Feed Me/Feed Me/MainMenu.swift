//
//  MainMenu.swift
//  Feed Me
//
//  Created by 20063914 on 03/12/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var playButton = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.Button))
    var playLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var soundOnBtn: SKSpriteNode?
    var soundOnLabel: SKLabelNode?
    
    var cutMultipleVinesBtn: SKSpriteNode?
    var cutMultipleVinesLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: ImageName.Background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.Background
        background.size = self.size
        addChild(background)
        
        playButton.position = CGPoint(x: size.width/2, y: size.height/2)
        playButton.size = playButton.texture!.size()
        playButton.name = "playBtn"
        playButton.zPosition = 1
        addChild(playButton)
        
        playLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        playLabel.text = "Play"
        playLabel.zPosition = 2
        addChild(playLabel)
        
        soundOnBtn = SKSpriteNode(imageNamed: ImageName.Checked)
        soundOnBtn!.position = CGPoint(x: size.width * 0.75, y: size.height * 0.30)
        soundOnBtn!.zPosition = 1
        soundOnBtn!.size = CGSize(width: 100, height: 100)
        addChild(soundOnBtn!)
        
        soundOnLabel = SKLabelNode(fontNamed: "Chalkduster")
        soundOnLabel!.text = "Enable Sound?"
        soundOnLabel!.position = CGPoint(x: size.width * 0.45, y: size.height * 0.29)
        addChild(soundOnLabel!)
        
        cutMultipleVinesBtn = SKSpriteNode(imageNamed: ImageName.Unchecked)
        cutMultipleVinesBtn!.position = CGPoint(x: size.width * 0.90, y: size.height * 0.20)
        cutMultipleVinesBtn!.zPosition = 1
        cutMultipleVinesBtn!.size = CGSize(width: 100, height: 100)
        addChild(cutMultipleVinesBtn!)
        
        cutMultipleVinesLabel = SKLabelNode(fontNamed: "Chalkduster")
        cutMultipleVinesLabel!.text = "Cut multiple vines at once?"
        cutMultipleVinesLabel!.position = CGPoint(x: size.width * 0.45, y: size.height * 0.19)
        addChild(cutMultipleVinesLabel!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            var shouldRun = false
            let delay = SKAction.wait(forDuration: 1)
            var sceneChange: SKAction?
            
            if objects.contains(playLabel) || objects.contains(playButton) {
                sceneChange = SKAction.run({
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
                })
                shouldRun = true
            } else if objects.contains(soundOnBtn!) {
                if GameConfiguration.playMusic {
                    GameConfiguration.playMusic = false
                    soundOnBtn!.texture = SKTexture(imageNamed: ImageName.Unchecked)
                } else {
                    GameConfiguration.playMusic = true
                    soundOnBtn!.texture = SKTexture(imageNamed: ImageName.Checked)
                }
            } else if objects.contains(cutMultipleVinesBtn!) {
                if GameConfiguration.CanCutMultipleVinesAtOnce {
                    GameConfiguration.CanCutMultipleVinesAtOnce = false
                    cutMultipleVinesBtn!.texture = SKTexture(imageNamed: ImageName.Unchecked)
                } else {
                    GameConfiguration.CanCutMultipleVinesAtOnce = true
                    cutMultipleVinesBtn!.texture = SKTexture(imageNamed: ImageName.Checked)
                }
            }
            
            if shouldRun {
                run(SKAction.sequence([delay, sceneChange!]))
            }
        }
        
    }
}
