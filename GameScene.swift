//
//  GameScene.swift
//  GameOfLife
//
//  Created by Max Bilbow on 03/07/2015.
//  Copyright (c) 2015 Rattle Media. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    /// The Game of Life
    private var life: GameOfLife?
    
    /// SKNodes that mirror bools in The Game of Life
    private var cells: [[GameOfLifeNode]]?
    
    /// Enables simple interaction with the game
    /// Touching a node will enable it. 
    /// For each of it's neighbours there will be a one in 'chance' of it also being activated. Default is 1 in 2.
    func reviveNodeAndNeighbours(node: GameOfLifeNode, oneIn chance: Int = 2) {
        self.life?.a.set(node.ref.x, y: node.ref.y, b: true)
        node.update()
        if let x: Int = node.ref.x - 1 where x > 0 {
            if random() % chance == 1 {
                self.life?.a.set(x, y: node.ref.y, b: true)
            }
        }
        if let x: Int = node.ref.x + 1 where x <= self.life?.w {
            if random() % chance == 1 {
                self.life?.a.set(x, y: node.ref.y, b: true)
            }
        }
        if let y: Int = node.ref.y - 1 where y > 0 {
            if random() % chance == 1 {
                self.life?.a.set(node.ref.x, y: y, b: true)
            }
        }
        if let y: Int = node.ref.y + 1 where y <= self.life?.h {
            if random() % chance == 1 {
                self.life?.a.set(node.ref.x, y: y, b: true)
            }
        }
        if let x: Int = node.ref.x + 1 where x <= self.life?.w, let y: Int = node.ref.y + 1 where y <= self.life?.h {
            if random() % chance == 1 {
                self.life?.a.set(x, y: y, b: true)
            }
        }
        if let x: Int = node.ref.x - 1 where x > 0, let y: Int = node.ref.y - 1 where y > 0 {
            if random() % chance == 1 {
                self.life?.a.set(x, y: y, b: true)
            }
        }
        if let x: Int = node.ref.x + 1 where x <= self.life?.w, let y: Int = node.ref.y - 1 where y > 0 {
            if random() % chance == 1 {
                self.life?.a.set(x, y: y, b: true)
            }
        }
        if let x: Int = node.ref.x - 1 where x > 0, let y: Int = node.ref.y + 1 where y <= self.life?.h {
            if random() % chance == 1 {
                self.life?.a.set(x, y: y, b: true)
            }
        }
        node.update() //Instant feedback
    }
    
    
    
    /// Animate the game and update the GameOfLife nodes to match their reference cells.
    override func update(currentTime: CFTimeInterval) {
        if let life = self.life , let cells = self.cells {
            life.step()
            for row in cells {
                for cell in row {
                    cell.update()
                }
            }
        }
    }
    
    /// Usually called by the ViewController or App delegate once the scene has been set up.
    /// This creates an array of nodes that matches the bools in the GameOfLife
    /// It can also be used to reset the game (untested)
    func setLife(nodeRadius radius: CGFloat = 5) {
        
        let width = Int(self.size.width / radius)
        let height = Int(self.size.height / radius)
        
        self.life = GameOfLife.new(width: width, height: height)
        
        self.cells = [[GameOfLifeNode]]()
        
        for var y = 0; y < self.life?.h; ++y {
            self.cells?.append([GameOfLifeNode]())
            for var x = 0; x < self.life?.w; ++x {
                self.cells?[y].append(GameOfLifeNode(life: self.life!, x: x, y: y, radius: radius).addToScene(self))
            }
        }
    }
}