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
    
    static var Square: [Vertex] = [
        Vertex(x:  1, y:  1, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x: -1, y:  1, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x:  1, y: -1, z: 0, r: 1, g: 1, b: 0, a: 1),
    ]
    
};


import Metal
import QuartzCore

class Shape {
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var device: MTLDevice
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice){
        // 1
        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        let vPtr: UnsafePointer<Array<Float>> = UnsafePointer<Array<Float>>(vertexData)
        
        // 2
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        self.vertexBuffer = device.newBufferWithBytes(vPtr, length: dataSize, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        
        // 3
        self.name = name
        self.device = device
        self.vertexCount = vertices.count
    }
    private static var _square: Shape?
    static var Square: Shape {
        return _square ?? { () -> Shape in
            _square = Shape(name: "Square", vertices: Vertex.Square, device: GameViewController.current.device)
            return _square!
        }()
    }
    
}

var quadVertexData: [Float] =
[
     1.0,  1.0, 0.0, 1.0,
    -1.0,  1.0, 0.0, 1.0,
    -1.0, -1.0, 0.0, 1.0,
    
     1.0,  1.0, 0.0, 1.0,
     1.0, -1.0, 0.0, 1.0,
    -1.0, -1.0, 0.0, 1.0,
    
]

let quadVertexColorData: [Float] =
[
    0.8,  0.0, 0.0, 1.0,
    0.0,  0.8, 0.0, 1.0,
    0.0,  0.0, 0.8, 1.0,
    
    0.8,  0.0, 0.0, 1.0,
    0.8,  0.8, 0.0, 1.0,
    0.0,  0.0, 0.8, 1.0,
]


let triVertexData:[Float] =
[
    -1.0, -1.0, 0.0, 1.0,
    -1.0,  1.0, 0.0, 1.0,
    1.0, -1.0, 0.0, 1.0,
    
    1.0, -1.0, 0.0, 1.0,
    -1.0,  1.0, 0.0, 1.0,
    1.0,  1.0, 0.0, 1.0,
    
    -0.0, 0.25, 0.0, 1.0,
    -0.25, -0.25, 0.0, 1.0,
    0.25, -0.25, 0.0, 1.0
]

let triVertexColorData:[Float] =
[
    0.0, 0.0, 1.0, 1.0,
    0.0, 0.0, 1.0, 1.0,
    0.0, 0.0, 1.0, 1.0,
    
    0.0, 0.0, 1.0, 1.0,
    0.0, 0.0, 1.0, 1.0,
    0.0, 0.0, 1.0, 1.0,
    
    0.0, 0.0, 1.0, 1.0,
    0.0, 1.0, 0.0, 1.0,
    1.0, 0.0, 0.0, 1.0
]