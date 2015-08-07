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

class GameScene {
    
    var size: NSSize!
    var life: Life?
    var cells: [[GameOfLifeNode]] = [[GameOfLifeNode]]()
    
    init(size: NSSize, inout verts: [Float]) {
        self.size = size//AppDelegate.window.contentLayoutRect.size
        self.setLife()
        self.scaleVertices(&verts, scale: 1 / self.life!.width)
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
//            print(life)
        }
    }
    
    func setLife(shape: GameOfLifeNode.Shape = .Square) {
        let bounds = self.size
        let radius: CGFloat = 5
        self.life = Life.new(bounds.width / radius, height: bounds.height / radius)
        
        for var y = 0; y < self.life?.h; ++y {
            self.cells.append([GameOfLifeNode]())
            for var x = 0; x < self.life?.w; ++x {
                self.cells[y].append(GameOfLifeNode(life: self.life!, x: x, y: y, radius: Float(radius), shape: shape))
                
            }
        }
    }
    
    func addChild(node: GameOfLifeNode) {
        
    }
}