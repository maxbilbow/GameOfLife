//
//  MTLNode.swift
//  GameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright © 2015 Max Bilbow. All rights reserved.
//

import Foundation
import GLKit;
class GameOfLifeNode  {
    enum Error: ErrorType {
        case BufferLargerThanRadius
    }
    
    var ref: (x: Int, y: Int)
    private var life: Life
    private var shape: Shape
    var radius: Float
    var hidden: Bool = false
    
    var position: (x: Float, y: Float) = (0,0)
//    var position: GLKVector3 {
//        let t = self.transform;
//        return GLKVector3Make(t.m30, t.m31, t.m32)
//    }
    
    var transform: GLKMatrix4 = GLKMatrix4Identity
    
    enum Shape {
        case Square, Circle
    }
    init(life: Life, x: Int, y: Int, radius: Float, buffer: Float = 2, shape: Shape = .Square) {
        self.ref = (x,y)
        self.life = life
        self.radius = radius
        self.shape = shape;
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
    
    func positionNode(buffer: Float) throws {
        self.radius -= buffer
        let d = ( self.radius + buffer ) * 2
        if self.radius <= 0 {
            throw Error.BufferLargerThanRadius
        }
        self.position.x = Float(self.ref.x) * d
        self.position.y = Float(self.ref.y) * d
    }
    
    func update() {
        self.hidden = !self.life.a.alive(self.ref.x, y: self.ref.y)
    }
    
//    func addToScene(view: GameView) -> Self {
//        view.addChild(self)
//        return self
//    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}