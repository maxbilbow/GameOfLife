//
//  GameOfLifeNode.swift
//  ShakespeareLogic
//
//  Created by Max Bilbow on 02/07/2015.
//  Copyright © 2015 Rattle Media. All rights reserved.
//

import Foundation
import SpriteKit



class GameOfLifeNode : SKNode {
    enum Error: ErrorType {
        case BufferLargerThanRadius
    }
    
    var ref: (x: Int, y: Int)
    private var life: Life
    private var shape: SKShapeNode
    var radius: CGFloat
    
    init(life: Life, x: Int, y: Int, radius: CGFloat, buffer: CGFloat = 2) {
        self.ref = (x,y)
        self.life = life
        self.radius = radius
        self.shape = SKShapeNode(circleOfRadius: radius)
        super.init()
        self.addChild(self.shape)
        self.shape.fillColor = NSColor.yellowColor()
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
    
    func positionNode(buffer: CGFloat) throws {
        self.radius -= buffer
        let d = ( self.radius + buffer ) * 2
        if self.radius <= 0 {
            throw Error.BufferLargerThanRadius
        }
        self.position.x = CGFloat(self.ref.x) * d
        self.position.y = CGFloat(self.ref.y) * d
    }
    
    func update() {
        self.hidden = !self.life.a.alive(self.ref.x, y: self.ref.y)
    }
    
    func addToScene(scene: SKScene) -> Self {
        scene.addChild(self)
        return self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}