//
//  GameOfLifeNode.swift
//  GameOfLife
//
//  Created by Max Bilbow on 02/07/2015.
//  Copyright © 2015 Rattle Media. All rights reserved.
//

import Foundation
import SpriteKit

///SpriteKit node used to reference a cell in the Game of Life.
class GameOfLifeNode : SKNode {
    
    enum Error: ErrorType {
        case BufferLargerThanRadius
    }
    
    ///Reference to the Bool in the Game
    var ref: (x: Int, y: Int)
    
    ///The game that this node is a part of
    private var life: GameOfLife
    
    ///The shape of the node. This is not required but may be useful in the future.
    private var shape: SKShapeNode
    
    ///The radius of the shape
    var radius: CGFloat
    
    ///Initialise a GameOfLifeNode that references a cell (x,y) in the current game.
    init(life: GameOfLife, x: Int, y: Int, radius: CGFloat, buffer: CGFloat = 2) {
        self.ref = (x,y)
        self.life = life
        self.radius = radius
        self.shape = SKShapeNode(circleOfRadius: radius)
        super.init()
        self.addChild(self.shape)
        self.shape.fillColor = RMColor.yellowColor()
        self.shape.lineWidth = 0 //= NSColor.greenColor()
        do {
            try self.positionNode(buffer)
        } catch {
            do {
                print("Warning: buffer was too large")
                try self.positionNode(0)
            } catch {
                fatalError("radius cannot be zero")
            }
        }
    }
    
    ///Sets the initial position of the node, based on it's radius and the number of cells
    ///The radius is a factor of the scene's size
    func positionNode(buffer: CGFloat) throws {
        self.radius -= buffer
        let d = ( self.radius + buffer ) * 2
        if self.radius <= 0 {
            throw Error.BufferLargerThanRadius
        }
        self.position.x = CGFloat(self.ref.x) * d
        self.position.y = CGFloat(self.ref.y) * d
    }
    
    ///Sets the node's visibility to match the cell in the game
    func update() {
        self.hidden = !self.life.a.alive(self.ref.x, y: self.ref.y)
    }
    
    ///Helper method when adding a new node to an array
    func addToScene(scene: SKScene) -> Self {
        scene.addChild(self)
        return self
    }
    
    var neighbours: [(x: Int, y: Int)] {
        var result = [ self.ref ]
        let x = self.ref.x; let y = self.ref.y
        for var i = -1; i <= 1; i++ {
            for var j = -1; j <= 1; j++ {
                let cell: (x: Int, y: Int) = (x + i, y + j)
                if (j != 0 || i != 0) && cell.x >= 0 && cell.x < self.life.w && cell.y >= 0 && cell.y < self.life.h {
                    result.append(cell)
                }
            }
        }
        return result
    }
    
    /// Enables simple interaction with the game
    /// Touching a node will enable it.
    /// For each of it's neighbours there will be a one in 'chance' of it also being activated. Default is 1 in 2.
    func reviveNodeAndNeighbours(oneIn chance: Int = 2) {
        for cell in self.neighbours {
            if random() % chance == 1 {
                self.life.a.set(cell.x, y: cell.y, b: true)
            }
        }
        self.update()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}