//
//  VertexData.swift
//  GameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright © 2015 Max Bilbow. All rights reserved.
//

import Foundation


struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
};


import GLKit
typealias Matrix4 = GLKMatrix4

extension Matrix4 {
    static func makePerspectiveViewAngle(radians radians: Float, aspect: Float, nearZ: Float, farZ: Float) -> Matrix4 {
        return GLKMatrix4MakePerspective(radians, aspect, nearZ, farZ)
    }
    
    static func makePerspectiveViewAngle(degrees degrees: Float, aspect: Float, nearZ: Float, farZ: Float) -> Matrix4 {
        return makePerspectiveViewAngle(radians: GLKMathDegreesToRadians(degrees), aspect: aspect, nearZ: nearZ, farZ: farZ)
    }
    
    func multiplyLeft(right:Matrix4) -> Matrix4 {
        return GLKMatrix4Multiply(self, right)
    }
    
    mutating func translate(x: Float, y: Float, z: Float) {
        self = GLKMatrix4Translate(self, x, y, z)
    }
    
    mutating func rotateAbout(rx x: Float = 0, ry y: Float = 0, rz z: Float = 0) {
        if x != 0 {
            self = GLKMatrix4RotateX(self, x)
        }
        if y != 0 {
            self = GLKMatrix4RotateY(self, y)
        }
        if z != 0 {
            self = GLKMatrix4RotateZ(self, z)
        }
    }
    
    
    mutating func rotateAbout(dx x: Float = 0, dy y: Float = 0, dz z: Float = 0) {
        self.rotateAbout(
            rx: GLKMathDegreesToRadians(x),
            ry: GLKMathDegreesToRadians(y),
            rz: GLKMathDegreesToRadians(z)
        )
    }
    
    
    mutating func rotateAroundX(rx x: Float = 0, ry y: Float = 0, rz z: Float = 0) {
        if x != 0 {
            self = GLKMatrix4RotateX(self, x)
        }
        if y != 0 {
            self = GLKMatrix4RotateX(self, y)
        }
        if z != 0 {
            self = GLKMatrix4RotateX(self, z)
        }
    }
    
    
    mutating func rotateAroundX(dx x: Float = 0, dy y: Float = 0, dz z: Float = 0) {
        self.rotateAbout(
            rx: GLKMathDegreesToRadians(x),
            ry: GLKMathDegreesToRadians(y),
            rz: GLKMathDegreesToRadians(z)
        )
    }
    
    mutating func scale(x: Float, y: Float, z: Float) {
        self = GLKMatrix4Scale(self, x, y, z)
    }

    mutating func raw() -> UnsafePointer<Void> {
        return GLKMatrix4UnsafePointer(&self)
//        let ptr = UnsafePointer<Float>(m)
////        ptr.memory = self
////        //        ptr.memory = self
//        return ptr
    }
//    var raw: UnsafePointer<Matrix4> {
//        var ptr = UnsafePointer<Matrix4>()
//        ptr.memory = self
//        return ptr
//    }
//    
    static let numberOfElements: Int = 16
    
}



//
//
//var quadVertexData: [Float] =
//[
//     1.0,  1.0, 0.0, 1.0,
//    -1.0,  1.0, 0.0, 1.0,
//    -1.0, -1.0, 0.0, 1.0,
//    
//     1.0,  1.0, 0.0, 1.0,
//     1.0, -1.0, 0.0, 1.0,
//    -1.0, -1.0, 0.0, 1.0,
//    
//]
//
//let quadVertexColorData: [Float] =
//[
//    0.8,  0.0, 0.0, 1.0,
//    0.0,  0.8, 0.0, 1.0,
//    0.0,  0.0, 0.8, 1.0,
//    
//    0.8,  0.0, 0.0, 1.0,
//    0.8,  0.8, 0.0, 1.0,
//    0.0,  0.0, 0.8, 1.0,
//]
//
//
//let triVertexData:[Float] =
//[
//    -1.0, -1.0, 0.0, 1.0,
//    -1.0,  1.0, 0.0, 1.0,
//    1.0, -1.0, 0.0, 1.0,
//    
//    1.0, -1.0, 0.0, 1.0,
//    -1.0,  1.0, 0.0, 1.0,
//    1.0,  1.0, 0.0, 1.0,
//    
//    -0.0, 0.25, 0.0, 1.0,
//    -0.25, -0.25, 0.0, 1.0,
//    0.25, -0.25, 0.0, 1.0
//]
//
//let triVertexColorData:[Float] =
//[
//    0.0, 0.0, 1.0, 1.0,
//    0.0, 0.0, 1.0, 1.0,
//    0.0, 0.0, 1.0, 1.0,
//    
//    0.0, 0.0, 1.0, 1.0,
//    0.0, 0.0, 1.0, 1.0,
//    0.0, 0.0, 1.0, 1.0,
//    
//    0.0, 0.0, 1.0, 1.0,
//    0.0, 1.0, 0.0, 1.0,
//    1.0, 0.0, 0.0, 1.0
//]