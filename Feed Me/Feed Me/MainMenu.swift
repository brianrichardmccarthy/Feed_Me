//
//  MainMenu.swift
//  Feed Me
//
//  Created by 20063914 on 03/12/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: ImageName.Background)
    
    override func didMove(to view: SKView) {
        
        print("\tMenu loaded")
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in: view)
            let node = atPoint(pos)
            if node == playButton {
                print("\tChanging scene")
                let delay = SKAction.wait(forDuration: 1)
                let sceneChange = SKAction.run({
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
                })
                run(SKAction.sequence([delay, sceneChange]))
            }
        }
        
    }
    
}
