//
//  SKSpriteNode+factory.swift
//  Snake
//
//  Created by Ramy Al Zuhouri on 11/09/15.
//  Copyright (c) 2015 Ramy Al Zuhouri. All rights reserved.
//

import Foundation
import SpriteKit

enum Orientation: UInt8 {
    case Up, Down, Right, Left
}

func+ (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y)
}

func- (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPointMake(p1.x - p2.x, p1.y - p2.y)
}

func* (size: CGSize, multiplier: CGFloat) -> CGSize {
    return CGSizeMake(size.width * multiplier, size.height * multiplier)
}

func magnitudeFromPoint(point: CGPoint) -> CGFloat {
    return sqrt(point.x * point.x + point.y * point.y)
}

func angleFromPoint(point: CGPoint) -> CGFloat {
    let magnitude = magnitudeFromPoint(point)
    let direction = CGPointMake(point.x / magnitude, point.y / magnitude)
    let angle = atan2(direction.y, direction.x)
    
    if angle < 0 {
        return CGFloat(2 * M_PI) - fabs(angle)
    } else {
        return angle
    }
}

extension SKSpriteNode {
    
    class func grass(size: CGSize, position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "grass")
        sprite.position = position
        sprite.size = size
        return sprite
    }
    
    class func stone(size: CGSize, position: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "stone")
        sprite.position = position
        sprite.size = size
        return sprite
    }

}

extension SKShapeNode {

    class func GreenCircle(size: CGSize, position: CGPoint) -> SKShapeNode {
        let shape = SKShapeNode(circleOfRadius: min(size.width * 0.49,size.height * 0.49))
        shape.position = position
        shape.fillColor = SKColor.greenColor()
        shape.strokeColor = SKColor.blackColor()
        shape.lineWidth = 0.5
        
        return shape
    }
    
    class func BlackRect(size: CGSize, position: CGPoint) -> SKShapeNode {
        let shape = SKShapeNode(rectOfSize: size * 0.98)
        shape.position = position
        shape.fillColor = SKColor.blackColor()
        shape.strokeColor = SKColor.blackColor()
        
        return shape
    }
    
    class func SnakeHead(size: CGSize, position: CGPoint, orientation: Orientation) -> SKShapeNode
    {
        let head = SKShapeNode.GreenCircle(size, position: position)
        
        let quarter = min(size.width / 4, size.height / 4)
        
        let upRight = SKShapeNode(circleOfRadius: quarter / 2)
        upRight.position = CGPointMake(quarter, quarter)
        upRight.fillColor = SKColor.blackColor()
        
        let upLeft = SKShapeNode(circleOfRadius: quarter / 2)
        upLeft.position = CGPointMake(-quarter, quarter)
        upLeft.fillColor = SKColor.blackColor()
        
        let downRight = SKShapeNode(circleOfRadius: quarter / 2)
        downRight.position = CGPointMake(quarter, -quarter)
        downRight.fillColor = SKColor.blackColor()
        
        let downLeft = SKShapeNode(circleOfRadius: quarter / 2)
        downLeft.position = CGPointMake(-quarter, -quarter)
        downLeft.fillColor = SKColor.blackColor()
        
        switch orientation {
        case .Right:
            head.addChild(upRight)
            head.addChild(downRight)
            break
        case .Left:
            head.addChild(upLeft)
            head.addChild(downLeft)
            break
        case .Up:
            head.addChild(upRight)
            head.addChild(upLeft)
            break
        case .Down:
            head.addChild(downRight)
            head.addChild(downLeft)
            break
        }
        
        return head
    }
}









