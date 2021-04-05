//
//  LabelGame.swift
//  StepUpGame
//
//  Created by Tuấn Việt on 30/03/2021.
//

import Foundation
import SpriteKit

class LabelGame: SKLabelNode {
    init(name: String, textColor: UIColor){
        super.init()
        let scaleAnimation = SKAction.scale(to: 3.0, duration: 0.8)
        let blurAnimation = SKAction.fadeAlpha(to: 0.0, duration: 0.8)
        text = name
        fontColor = textColor
        fontName = "Adumu"
        fontSize = 40
        zPosition = 3.0;
        position = CGPoint(x: 0, y: 0)
        run(SKAction.group([scaleAnimation, blurAnimation])) {
            self.removeFromParent()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
