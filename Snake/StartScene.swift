//
//  StartScene.swift
//  Snake
//
//  Created by Ramy Al Zuhouri on 13/09/15.
//  Copyright (c) 2015 Ramy Al Zuhouri. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.greenColor()
        
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.position = CGPointMake(frame.width / 2.0, frame.height * 0.6)
        label.text = "Snake"
        label.fontSize = 50.0
        self.addChild(label)
        
        let descriptionLabel = SKLabelNode(fontNamed: "Marker Felt")
        descriptionLabel.position = CGPointMake(frame.width / 2.0, frame.height * 0.4)
        descriptionLabel.text = "Tap anywhere to start"
        descriptionLabel.fontSize = 20.0
        self.addChild(descriptionLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let transition = SKTransition.doorsOpenVerticalWithDuration(2.0)
        let game = GameScene(size: frame.size, level: 1)
        self.view!.presentScene(game, transition: transition)
    }
}








