//
//  GameScene.swift
//  Snake
//
//  Created by Ramy Al Zuhouri on 10/09/15.
//  Copyright (c) 2015 Ramy Al Zuhouri. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private let rows: UInt = 15
    private let columns: UInt = 10
    private let snake = SKNode()
    private var level: UInt
    private var snakeOrientation: Orientation = .Right
    private var delay: NSTimeInterval = 1.0
    private var fruitsToEat: UInt = 10
    private var collision = false
    private var fruits = [SKSpriteNode]()
    private var fruitsToDrop: UInt = 1
    private var snakeSize: UInt = 7
    private var points: UInt = 0 {
        didSet {
            pointsLabel.text = "Level \(level) (\(points)/\(fruitsToEat)) Lives: \(lives)"
        }
    }
    private var pointsLabel: SKLabelNode!
    private var hole: SKShapeNode?
    private var levelUp = false
    private var nextOrientation: Orientation = .Right
    private var disappearCounter: UInt = 100
    private var counters = [UInt]()
    private var freePositions = [CGPoint]()
    private var stonesPositions = [CGPoint]()
    private var lives: UInt = 3
    
    private var cellSize: CGSize {
        return CGSizeMake(self.size.width / CGFloat(columns), self.size.height / CGFloat(rows))
    }
    
    private func initializeLevel() {
        switch level {
        case 1:
            delay = 0.8
            fruitsToEat = 10
            disappearCounter = 50
            fruitsToDrop = 1
            break
        case 2:
            delay = 0.75
            fruitsToEat = 15
            disappearCounter = 30
            fruitsToDrop = 1
            break
        case 3:
            delay = 0.7
            fruitsToEat = 25
            disappearCounter = 20
            fruitsToDrop = 2
            break
        case 4:
            delay = 0.65
            fruitsToEat = 35
            disappearCounter = 15
            fruitsToDrop = 3
            break
        case 5:
            delay = 0.6
            fruitsToEat = 50
            disappearCounter = 12
            fruitsToDrop = 4
        default:
            break
        }
    }
    
    init(size: CGSize, level: UInt) {
        self.level = level
        super.init(size: size)
        initializeLevel()
    }
    
    init(size: CGSize, level: UInt, lives: UInt) {
        self.lives = lives
        self.level = level
        super.init(size: size)
        initializeLevel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        level = UInt(aDecoder.decodeIntegerForKey("level"))
        super.init(coder: aDecoder)
        initializeLevel()
    }
    
    // MARK: - DidMoveToView
    override func didMoveToView(view: SKView) {
        // Add the points label
        pointsLabel = SKLabelNode(fontNamed: "Marker Felt")
        pointsLabel.fontSize = 18
        pointsLabel.position = CGPointMake(cellSize.width * 2.75, size.height - cellSize.height * 0.6)
        pointsLabel.text = "Level \(level) (\(points)/\(fruitsToEat)) Lives: \(lives)"
        pointsLabel.zPosition = 3.0
        self.addChild(pointsLabel)
        
        // Add the grass
        for var row: UInt = 0; row < rows; row++ {
            for var column: UInt = 0; column < columns; column++ {
                let sprite = SKSpriteNode.grass(cellSize, position: cellPosition(atRow: row, column: column))
                self.addChild(sprite)
            }
        }
        
        // Initialize the stones' positions
        if level == 1 || level == 2 {
            stonesPositions = [
                cellPosition(atRow: 10, column: 1),
                cellPosition(atRow: 10, column: 2),
                cellPosition(atRow: 10, column: 3),
                cellPosition(atRow: 9, column: 1),
                cellPosition(atRow: 10, column: 6),
                cellPosition(atRow: 10, column: 7),
                cellPosition(atRow: 10, column: 8),
                cellPosition(atRow: 9, column: 8),
                cellPosition(atRow: 5, column: 1),
                cellPosition(atRow: 4, column: 1),
                cellPosition(atRow: 4, column: 2),
                cellPosition(atRow: 4, column: 3),
                cellPosition(atRow: 5, column: 8),
                cellPosition(atRow: 4, column: 8),
                cellPosition(atRow: 4, column: 7),
                cellPosition(atRow: 4, column: 6)
            ]
            if level == 2 {
                stonesPositions.append(cellPosition(atRow: 6, column: 3))
                stonesPositions.append(cellPosition(atRow: 6, column: 6))
                stonesPositions.append(cellPosition(atRow: 8, column: 6))
                stonesPositions.append(cellPosition(atRow: 8, column: 3))
            }
        } else if level == 3 {
            stonesPositions = [
                cellPosition(atRow: 12, column: 2),
                cellPosition(atRow: 12, column: 7),
                cellPosition(atRow: 10, column: 4),
                cellPosition(atRow: 10, column: 5),
                cellPosition(atRow: 8, column: 2),
                cellPosition(atRow: 8, column: 3),
                cellPosition(atRow: 8, column: 6),
                cellPosition(atRow: 8, column: 7),
                cellPosition(atRow: 6, column: 2),
                cellPosition(atRow: 6, column: 3),
                cellPosition(atRow: 6, column: 6),
                cellPosition(atRow: 6, column: 7),
                cellPosition(atRow: 4, column: 4),
                cellPosition(atRow: 4, column: 5),
                cellPosition(atRow: 2, column: 2),
                cellPosition(atRow: 2, column: 7)
            ]
            
        } else if level == 4 {
            stonesPositions = [
                cellPosition(atRow: 11, column: 2),
                cellPosition(atRow: 11, column: 4),
                cellPosition(atRow: 11, column: 5),
                cellPosition(atRow: 11, column: 7),
                cellPosition(atRow: 11, column: 1),
                cellPosition(atRow: 11, column: 8),
                cellPosition(atRow: 10, column: 8),
                cellPosition(atRow: 10, column: 1),
                cellPosition(atRow: 9, column: 3),
                cellPosition(atRow: 9, column: 6),
                cellPosition(atRow: 8, column: 2),
                cellPosition(atRow: 8, column: 3),
                cellPosition(atRow: 8, column: 6),
                cellPosition(atRow: 8, column: 7),
                cellPosition(atRow: 7, column: 0),
                cellPosition(atRow: 7, column: 9),
                cellPosition(atRow: 6, column: 2),
                cellPosition(atRow: 6, column: 3),
                cellPosition(atRow: 6, column: 6),
                cellPosition(atRow: 6, column: 7),
                cellPosition(atRow: 5, column: 3),
                cellPosition(atRow: 5, column: 6),
                cellPosition(atRow: 4, column: 1),
                cellPosition(atRow: 4, column: 8),
                cellPosition(atRow: 3, column: 2),
                cellPosition(atRow: 3, column: 4),
                cellPosition(atRow: 3, column: 5),
                cellPosition(atRow: 3, column: 7),
                cellPosition(atRow: 3, column: 1),
                cellPosition(atRow: 3, column: 8)
            ]
        } else if level == 5 {
            // Change the snake's next orientation
            nextOrientation = .Down
            
            stonesPositions = [
                cellPosition(atRow: 12, column: 3),
                cellPosition(atRow: 12, column: 6),
                cellPosition(atRow: 10, column: 4),
                cellPosition(atRow: 10, column: 5),
                cellPosition(atRow: 8, column: 4),
                cellPosition(atRow: 8, column: 5),
                cellPosition(atRow: 6, column: 4),
                cellPosition(atRow: 6, column: 5),
                cellPosition(atRow: 4, column: 4),
                cellPosition(atRow: 4, column: 5),
                cellPosition(atRow: 2, column: 3),
                cellPosition(atRow: 2, column: 6)
            ]
            
            for var row: UInt = 0; row < rows; row++ {
                stonesPositions.append(cellPosition(atRow: row, column: 0))
                stonesPositions.append(cellPosition(atRow: row, column: columns - 1))
            }
            
            for var column:UInt = 1; column < columns - 1; column++ {
                stonesPositions.append(cellPosition(atRow: 0, column: column))
                stonesPositions.append(cellPosition(atRow: rows - 1, column: column))
            }
            
            for var row:UInt = 2; row <= 12; row++ {
                if row != 8 && row != 6 {
                    stonesPositions.append(cellPosition(atRow: row, column: 2))
                    stonesPositions.append(cellPosition(atRow: row, column: 7))
                }
            }
        }
        
        // Initialize all the free positions
        for var row:UInt = 0; row < rows; row++ {
            for var column: UInt = 0; column < columns; column++ {
                let position = cellPosition(atRow: row, column: column)
                if !stonesPositions.contains(position) {
                    freePositions.append(position)
                }
            }
        }
        
        
        // Add the stones
        var i = 0
        for position in stonesPositions {
            let stone = SKSpriteNode.stone(cellSize, position: position)
            stone.zPosition = 1
            stone.name = "stone \(i)"
            self.addChild(stone)
            i++
        }
        
        // Add the snake
        self.addChild(snake)
        
        let snakeRow = level == 5 ? rows - 2 : rows - 1
        let columnRange = level == 5 ? 1...7 : 0...6
        for column in columnRange {
            let position = cellPosition(atRow: snakeRow, column: UInt(column))
            freePositions.removeAtIndex(freePositions.indexOf(position)!)
            
            let circle = SKShapeNode.GreenCircle(cellSize, position: position)
            circle.zPosition = 1
            circle.name = String("snake \(level == 5 ? column - 1 : column)")
            snake.addChild(circle)
        }

        let headPosition = cellPosition(atRow: snakeRow, column: UInt(columnRange.last! + 1))
        freePositions.removeAtIndex(freePositions.indexOf(headPosition)!)
        let head = SKShapeNode.SnakeHead(cellSize, position: headPosition, orientation: .Right)
        head.zPosition = 1
        head.name = "head"
        for eye: SKShapeNode in head.children as! [SKShapeNode] {
            eye.zPosition = 2
        }
        snake.addChild(head)
        
        // Move the snake forever
        let wait = SKAction.waitForDuration(delay)
        let move = SKAction.customActionWithDuration(0.0, actionBlock: { node, time in
            self.moveSnake()
        })
        let sequence = SKAction.sequence([wait, move])
        let `repeat` = SKAction.repeatActionForever(sequence)
        self.runAction(`repeat`)
        
        // Add a tap gesture recognizer to move the snake
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
        self.view!.addGestureRecognizer(panRecognizer)
        
        // Drop the fruits
        for var i:UInt = 0; i < fruitsToDrop; i++ {
            self.counters.append(0)
            self.dropFruit(Int(i))
        }
        
    }
    
    // MARK: -
    func cellPosition(atRow row: UInt, column: UInt) -> CGPoint {
        let halfWidth: CGFloat = cellSize.width / 2
        let halfHeight: CGFloat = cellSize.height / 2
        return CGPointMake(cellSize.width * CGFloat(column) + halfWidth, cellSize.height * CGFloat(row) + halfHeight)
    }
    
    // MARK: - Move Snake
    func moveSnake() {
        
        if collision {
            lives--
            let transition = SKTransition.doorsCloseHorizontalWithDuration(2.0)
            var newScene: SKScene
            if lives == 0 {
                // Game over
                newScene = GameOverScene(size: size)
            } else {
                // Lose a life and restart the level
                newScene = GameScene(size: size, level: level, lives: lives)
            }
            view!.presentScene(newScene, transition: transition)
            return
        } else if levelUp {
            var scene: SKScene
            let transition = SKTransition.doorwayWithDuration(2.0)
            if level == 5 {
                scene = StartScene(size: size)
            } else {
                scene = GameScene(size: size, level: level + 1, lives: lives)
            }
            view!.presentScene(scene, transition: transition)
            return
        }
        
        for var i = 0; i < counters.count; i++ {
            counters[i]++
        }
        
        var head = snake.childNodeWithName("head")!
        let headPosition = head.position
        
        // Replace snake's head
        if nextOrientation != snakeOrientation {
            snake.removeChildrenInArray([head])
            head = SKShapeNode.SnakeHead(cellSize, position: head.position, orientation: nextOrientation)
            head.zPosition = 1
            head.name = "head"
            for eye: SKShapeNode in head.children as! [SKShapeNode] {
                eye.zPosition = 2
            }
            snake.addChild(head)
        }
        
        snakeOrientation = nextOrientation
        if snakeOrientation == .Right {
            head.position = head.position + CGPointMake(cellSize.width, 0)
            if head.position.x > size.width {
                head.position.x = cellSize.width / 2
            }
        } else if snakeOrientation == .Left {
            head.position = head.position - CGPointMake(cellSize.width, 0)
            if head.position.x < 0 {
                head.position.x = size.width - cellSize.width / 2
            }
        } else if snakeOrientation == .Up {
            head.position = head.position + CGPointMake(0, cellSize.height)
            if head.position.y > size.height {
                head.position.y = cellSize.height / 2
            }
        } else if snakeOrientation == .Down {
            head.position = head.position - CGPointMake(0, cellSize.height)
            if head.position.y < 0 {
                head.position.y = size.height - cellSize.height / 2
            }
        }
        
        // Remove the head's position from the free positions
        // If there's a collision with the snake's body this wouldn't 
        // remove any position
        let index = freePositions.indexOf(head.position)
        if index != nil {
            freePositions.removeAtIndex(index!)
        } else {
            print("Head's position hasn't been removed from the free positions, this means that there has been a collision")
        }
        
        var eatenFruitIndex: Int?
        for var i = 0; i < fruits.count; i++ {
            let fruit = fruits[i]
            if CGPointEqualToPoint(fruit.position, head.position) {
                eatenFruitIndex = i
                break
            }
        }
        
        if eatenFruitIndex != nil {
            self.removeChildrenInArray([self.fruits[eatenFruitIndex!]])
            self.fruits.removeAtIndex(eatenFruitIndex!)
            self.points++
            self.addCircle(headPosition)
            if points < fruitsToEat {
                dropFruit(eatenFruitIndex!)
            } else {
                self.counters.removeAtIndex(eatenFruitIndex!)
                if hole == nil {
                    hole = SKShapeNode.BlackRect(cellSize, position: randomFreePosition())
                    hole!.zPosition = 2.0
                    self.addChild(hole!)
                }
            }
        } else {
            let last = snake.childNodeWithName("snake 0")!
            freePositions.append(last.position)
            
            last.position = headPosition
            
            for var i: UInt = 1; i < snakeSize; i++ {
                let circle = snake.childNodeWithName("snake \(i)")!
                circle.name = "snake \(i - 1)"
            }
            last.name = "snake \(snakeSize - 1)"
        }
        
        // Remove the fruits if time is expired
        for var i = 0; i < counters.count; i++ {
            if counters[i] >= disappearCounter {
                self.removeChildrenInArray([fruits[i]])
                fruits.removeAtIndex(i)
                if points < fruitsToEat {
                    dropFruit(i)
                } else {
                    counters.removeAtIndex(i)
                }
            }
        }
        
        collision = detectCollisions(snake.childNodeWithName("head")!.position)
        
        if let _ = hole {
            levelUp = CGPointEqualToPoint(head.position, hole!.position)
        }
    }
    // MARK: -
   
    func pan(panRecognizer: UIPanGestureRecognizer) {
        var translation = panRecognizer.translationInView(self.view!)
        translation.y = -translation.y
        let direction = angleFromPoint(translation)
        
        let firstTouch = self.convertPointFromView(panRecognizer.locationInView(self.view!) - panRecognizer.translationInView(self.view!))
        let headPosition = snake.childNodeWithName("head")!.position
        let distance = magnitudeFromPoint(headPosition - firstTouch)
        
        if distance > 4.0 * max(cellSize.width, cellSize.height) {
            return
        }
        
        let delta = CGFloat(M_PI / 6)
        let pi = CGFloat(M_PI)
        
        if direction < delta || direction > (2.0 * pi - delta) {
            if snakeOrientation != .Left {
                nextOrientation = .Right
            }
        } else if direction > (pi / 2.0 - delta) && direction < (pi / 2.0 + delta) {
            if snakeOrientation != .Down {
                nextOrientation = .Up
            }
        } else if direction > (pi - delta) && direction < (pi + delta) {
            if snakeOrientation != .Right {
                nextOrientation = .Left
            }
        } else if direction > (3.0 / 2 * pi - delta) && direction < (3.0 / 2 * pi + delta) {
            if snakeOrientation != .Up {
                nextOrientation = .Down
            }
        }
    }
    
    func detectCollisions(position: CGPoint) -> Bool {
        
        if stonesPositions.contains(position) {
            return true
        }
        
        for var i: UInt = 0; i < snakeSize; i++ {
            let name = "snake \(i)"
            let circle = snake.childNodeWithName(name)!
            if CGPointEqualToPoint(circle.position, position) {
                return true
            }
        }
        
        return false
    }
    
    // Uses the freePositions vector
    private func randomFreePosition() -> CGPoint {
        var position: CGPoint
        var occupiedByFruit: Bool
        
        repeat {
            let index = Int(arc4random_uniform(UInt32(freePositions.count)))
            position = freePositions[index]
            
            occupiedByFruit = false
            for fruit in fruits {
                if CGPointEqualToPoint(fruit.position, position) {
                    occupiedByFruit = true
                    break
                }
            }
        
        } while (occupiedByFruit)
        
        return position
    }
    
    private func dropFruit(index: Int) {
        let fruitTypes = ["cherry", "apple", "strawberry", "orange"]
        let fruit = SKSpriteNode(imageNamed: fruitTypes[Int(arc4random_uniform(UInt32(fruitTypes.count)))])
        fruit.size = cellSize
        fruit.name = "fruit"
        fruit.position = randomFreePosition()
        fruit.zPosition = 2.0
        self.addChild(fruit)
        self.fruits.insert(fruit, atIndex: index)
        self.counters[index] = 0
    }
    
    private func addCircle(position: CGPoint) {
        let circle = SKShapeNode.GreenCircle(cellSize, position: position)
        circle.zPosition = 1
        circle.name = "snake \(snakeSize)"
        snakeSize++
        snake.addChild(circle)
    }
}








