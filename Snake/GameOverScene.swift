//
//  GameOverScene.swift
//  Snake
//
//  Created by Ramy Al Zuhouri on 13/09/15.
//  Copyright (c) 2015 Ramy Al Zuhouri. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.grayColor()
        
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.position = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        label.text = "Game Over"
        label.fontSize = 50.0
        self.addChild(label)
        
        let wait = SKAction.waitForDuration(5.0)
        let swapScene = SKAction.customActionWithDuration(0.0, actionBlock: {node, time in
            self.presentStartScene()
        })
        self.runAction(SKAction.sequence([wait, swapScene]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        presentStartScene()
    }
    
    private func presentStartScene() {
        let transition = SKTransition.doorsOpenVerticalWithDuration(2.0)
        let startScene = StartScene(size: frame.size)
        self.view!.presentScene(startScene, transition: transition)
    }
}





