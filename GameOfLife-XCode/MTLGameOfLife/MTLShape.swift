//
//  MTLShape.swift
//  GameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright © 2015 Max Bilbow. All rights reserved.
//

import Foundation


import MetalKit
import QuartzCore
enum ShapeType {
    case Square
}
class Shape {
    
    var time:CFTimeInterval = 0.0
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var uniformBuffer: MTLBuffer?
    var device: MTLDevice
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice){
        // 1
        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        
        // 2
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(UnsafePointer<Void>(vertexData), length: dataSize, options: [])//(ConstantBufferSize, options: [])
        // 3
        self.name = name
        self.device = device
        vertexCount = vertices.count
    }
    
    func render(commandQueue: MTLCommandQueue,
        pipelineState: MTLRenderPipelineState,
        drawable: CAMetalDrawable,
        parentModelViewMatrix: Matrix4,
        projectionMatrix: UnsafePointer<Void>,
        clearColor: MTLClearColor?
        ) -> MTLCommandBuffer {
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 200/255, green: 200/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .Store
        
        let commandBuffer = commandQueue.commandBuffer()
        
        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
   
        //For now cull mode is used instead of depth buffer
        renderEncoder.setCullMode(MTLCullMode.Front)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        // 1
        var nodeModelMatrix = self.modelMatrix()
        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
        // 2
        uniformBuffer = device.newBufferWithLength(sizeof(Float) * Matrix4.numberOfElements * 2, options: [])
        // 3
        let bufferPointer = uniformBuffer?.contents()
        // 4
        memcpy(bufferPointer!, nodeModelMatrix.raw(),
            sizeof(Float)*Matrix4.numberOfElements)
        memcpy(bufferPointer! + sizeof(Float)*Matrix4.numberOfElements,
            projectionMatrix,
            sizeof(Float)*Matrix4.numberOfElements)
        // 5
        renderEncoder.setVertexBuffer(self.uniformBuffer, offset: 0, atIndex: 1)
        renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
        renderEncoder.endEncoding()
        
        return commandBuffer;
        
    }
    
    func modelMatrix() -> Matrix4 {
        var matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rx: rotationX, ry: rotationY, rz: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        NSLog(description)
        return matrix
    }
    
    func updateWithDelta(delta: CFTimeInterval){
        time += 1/60//delta
  
        let secsPerMove: Float = 6.0
        positionZ += 1/60
        rotationY = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        rotationX = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        
    }
    
    private static var _square: Shape?
    static var Square: Shape {
        return _square ?? { () -> Shape in
            _square = Shape(name: "Square", vertices: Vertex.Square, device: GameViewController.current.device)
            return _square!
            }()
    }
    private static var _cube: Shape?
    static var Cube: Shape {
        return _cube ?? { () -> Shape in
            _cube = Shape(name: "Cube", vertices: ACube.Verts, device: GameViewController.current.device)
            return _cube!
            }()
    }
    
    
    var description: String {
        return "\(positionX), \(positionY), \(positionZ)"
    }




    private struct ACube  {
        
        
        static let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        static let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        static let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        static let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        static let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        static let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        static let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        static let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        static var Verts:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right
            
            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        //    func updateWithDelta(delta: CFTimeInterval) {
        //
        //        super.updateWithDelta(delta)
        //
        //        var secsPerMove: Float = 6.0
        //        rotationY = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        //        rotationX = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        //    }
        
}
}
