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
    
    var optionsButton = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.Button))
    var optionsLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        playButton.position = CGPoint(x: size.width/2, y: size.height/2)
        playButton.size = playButton.texture!.size()
        playButton.name = "playBtn"
        playButton.zPosition = 1
        addChild(playButton)
        
        
        playLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        playLabel.text = "Play"
        playLabel.zPosition = 2
        addChild(playLabel)
        
        optionsButton.position = CGPoint(x: size.width/2, y: size.height * 0.4)
        optionsButton.size = optionsButton.texture!.size()
        optionsButton.name = "optionsBtn"
        optionsButton.zPosition = 1
        addChild(optionsButton)
        
        
        optionsLabel.position = CGPoint(x: size.width/2, y: size.height * 0.4)
        optionsLabel.text = "Options"
        optionsLabel.zPosition = 2
        addChild(optionsLabel)
        
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
            } else if objects.contains(playLabel) || objects.contains(playButton) {
                sceneChange = SKAction.run({
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
                })
                shouldRun = true
                
            }
            
            if shouldRun {
                run(SKAction.sequence([delay, sceneChange!]))
            }
        }
        
    }
}
