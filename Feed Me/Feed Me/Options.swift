//
//  MainMenu.swift
//  Feed Me
//
//  Created by 20063914 on 03/12/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit
import UIKit

class Options: SKScene {
    
    // var playButton = SKSpriteNode()
    // let playButtonTex = SKTexture(imageNamed: ImageName.Background)
    
    
    
    override func didMove(to view: SKView) {
        // playButton = SKSpriteNode(texture: playButtonTex)
        // playButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        // self.addChild(playButton)
        let switchControl = UISwitch(frame: CGRect(x: size.width / 2, y: size.height / 2, width: 0, height: 0))
        switchControl.addTarget(self, action: #selector(Options.swtichVolume(_:)), for: .valueChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for touch in touches {
        //     let pos = touch.location(in: view)
        //     let node = atPoint(pos)
        //     if node == playButton {
        //         let delay = SKAction.wait(forDuration: 1)
        //         let sceneChange = SKAction.run({
        //             let scene = GameScene(size: self.size)
        //             self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        //         })
        //         run(SKAction.sequence([delay, sceneChange]))
        //     }
        // }
        
    }
    
    @objc func swtichVolume(_ sender:UISwitch!) {
        print("Swap")
    }
    
}
