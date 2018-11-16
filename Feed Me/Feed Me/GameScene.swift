//
//  GameScene.swift
//  Feed Me
//
//  Created by Brian McCarthy on 16/11/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        //setUpPhysics()
        //etUpScenery()
        //setUpPrize()
        //setUpVines()
        //setUpCrocodile()
        //setUpAudio()
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics() { }
    fileprivate func setUpScenery() { }
    fileprivate func setUpPrize() { }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() { }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() { }
    fileprivate func animateCrocodile() { }
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) { }
    
    //MARK: - Touch handling
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) { }
    func didBegin(_ contact: SKPhysicsContact) { }
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) { }
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) { }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() { }
}
