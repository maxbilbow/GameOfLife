//
//  MTLScene.swift
//  GameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright © 2015 Max Bilbow. All rights reserved.
//

import Foundation
import SpriteKit
import MetalKit

//func =(inout lhs:(width: Float, height: Float), rhs: NSSize)  {
//    lhs.0 = Float(rhs.width)
//    lhs.1 = Float(rhs.height)
//}
class GameScene : CustomStringConvertible {
    
    private static var _gameScene: GameScene?
    
    static var current: GameScene {
        
        return _gameScene ?? GameScene()
    }
    var size: (width: Float, height: Float)
    var life: Life?
    var cells: [[GameOfLifeNode]] = [[GameOfLifeNode]]()
    var shape: ShapeType
    var cellRadius: Float = 0
    
    init(size: NSSize? = nil, shape: ShapeType = .Square) {
        self.shape = shape
        if let size = size ?? NSScreen.mainScreen()?.frame.size {
            self.size.width = Float(size.width)
            self.size.height = Float(size.height)
        } else {
            NSLog("WARNING: Size init problems in GameScene.init()...")
            let size = GameViewController.current.view.bounds.size
            self.size.width = Float(size.width)
            self.size.height = Float(size.height)
        }
        if (GameScene._gameScene == nil) {
            GameScene._gameScene = self
        } else {
            fatalError("Do not reinit")
        }
//        self.scaleVertices(&verts, scale: 1 / self.life!.width)
    }
   
    func scaleVertices(inout verts: [Float], scale: Float) {
        var i = 0
        for _ in verts {
            verts[i++] *= scale
        }
        
        
    }
    
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
        node.update()
    }
    
    func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
//        let location = theEvent.locationInWindow
        
//        if let node = nodeAtPoint(location).parent as? GameOfLifeNode ?? nodeAtPoint(location) as? GameOfLifeNode {
//            self.reviveNodeAndNeighbours(node)
//        }
        
        
    }
    
    private var lastTime: CFTimeInterval = 0
    func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //        if currentTime > lastTime {
        if let life = self.life {
            life.step()
            for row in self.cells {
                for cell in row {
                    cell.update()
                }
            }
//            NSLog("\(cells.count * cells[0].count) cells of size: \(self.cellRadius)\n\(life)")
        } else {
            self.prepareGame(self.shape)
            self.update(currentTime)
        }
    }
    
    func prepareGame(shape: ShapeType, maxNoOfCells: Float = 1000) {
        self.shape = shape
        self.cellRadius = (self.size.height + self.size.width) * 0.5 /  sqrt(maxNoOfCells)
        self.life = Life.new(self.size.width / self.cellRadius, height: self.size.height / self.cellRadius)
        
        for var y = 0; y < self.life?.h; ++y {
            self.cells.append([GameOfLifeNode]())
            for var x = 0; x < self.life?.w; ++x {
                self.cells[y].append(GameOfLifeNode(life: self.life!, x: x, y: y, radius: self.cellRadius, shape: shape))
                
            }
        }
        NSLog("\(self)")
    }
    
    var description: String {
        return "\(cells.count * cells[0].count) cells of size: \(self.cellRadius). INITIAL GAME:\n\(self.life), "
    }
    func addChild(node: GameOfLifeNode) {
        
    }
}