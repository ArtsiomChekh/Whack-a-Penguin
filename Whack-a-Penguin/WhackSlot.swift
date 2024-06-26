//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by avc on 23.04.24.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var isVisible = false
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            let fireEmitter = SKEmitterNode(fileNamed: "FireParticle.sks")!
            fireEmitter.position = charNode.position
            addChild(fireEmitter)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                fireEmitter.removeFromParent()
            }
            
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let smokeEmitter = SKEmitterNode(fileNamed: "SmokeParticle.sks")!
        smokeEmitter.position = charNode.position
        addChild(smokeEmitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                smokeEmitter.removeFromParent()
        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisable = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisable]))
    }
}
