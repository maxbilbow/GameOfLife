//
//  GameViewController.swift
//  MTLGameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright (c) 2015 Max Bilbow. All rights reserved.
//

import Cocoa
import MetalKit

let MaxBuffers = 3
let ConstantBufferSize = 1024*1024




class GameViewController: NSViewController, MTKViewDelegate {
    
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()!
//    var metalLayer: CAMetalLayer = CAMetalLayer()
    var commandQueue: MTLCommandQueue! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var vertexBuffer: MTLBuffer! = nil
//    var vertexColorBuffer: MTLBuffer! = nil
    
    let inflightSemaphore = dispatch_semaphore_create(MaxBuffers)
    var bufferIndex = 0
    
//    // offsets used in animation
//    var xOffset:[Float] = [ -1.0, 1.0, -1.0 ]
//    var yOffset:[Float] = [ 1.0, 0.0, -1.0 ]
//    var xDelta:[Float] = [ 0.002, -0.001, 0.003 ]
//    var yDelta:[Float] = [ 0.001,  0.002, -0.001 ]
//    var scene: GameScene!
    lazy var shapes: [Shape] = []
    static var current: GameViewController!
    
    override func viewDidLoad() {
        GameViewController.current = self
        super.viewDidLoad()
        
        
        // setup view properties
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
        view.sampleCount = 4
        loadAssets()
        
        print(GameScene.current.size)
    }

//    var pipelineStateDescriptor: MTLRenderPipelineDescriptor!
    func loadAssets() {
        shapes.append(Shape.Square)
        // load any resources required for rendering
        let view = self.view as! MTKView
        commandQueue = device.newCommandQueue()
        commandQueue.label = "main command queue"
        
        let defaultLibrary = device.newDefaultLibrary()!
        let fragmentProgram = defaultLibrary.newFunctionWithName("passThroughFragment")!
        let vertexProgram = defaultLibrary.newFunctionWithName("passThroughVertex")!
        
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineStateDescriptor.sampleCount = view.sampleCount
        
        
        do {
            try pipelineState = device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        
    }
  
    
    func drawInMTKView(view: MTKView) {
        GameScene.current.update(NSTimeIntervalSince1970)
        // use semaphore to encode 3 frames ahead
        dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER)
        
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.label = "Frame command buffer"
        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(view.currentRenderPassDescriptor!)
        renderEncoder.label = "render encoder"
       
        renderEncoder.setRenderPipelineState(pipelineState)
        for shape in self.shapes {
            renderEncoder.pushDebugGroup("draw \(shape.name)")
            shape.render(view, renderEncoder: renderEncoder, commandBuffer: commandBuffer, pipelineState: pipelineState, drawable: view.currentDrawable!, clearColor: nil)
            renderEncoder.popDebugGroup()
        }
        renderEncoder.endEncoding()

//        commandBuffer.label = "Frame command buffer"
//        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(view.currentRenderPassDescriptor!)
//        renderEncoder.label = "render encoder"
        
        
//
//        renderEncoder.setVertexBuffer(vertexBuffer, offset: 256*bufferIndex, atIndex: 0)
//        renderEncoder.setVertexBuffer(vertexColorBuffer, offset:0 , atIndex: 1)
//        renderEncoder.drawPrimitives(.TriangleStrip, vertexStart: 0, vertexCount: 6, instanceCount: 1)
       
        
//        renderEncoder.popDebugGroup()
//        renderEncoder.endEncoding()
    
        // use completion handler to signal the semaphore when this frame is completed allowing the encoding of the next frame to proceed
        // use capture list to avoid any retain cycles if the command buffer gets retained anywhere besides this stack frame
        commandBuffer.addCompletedHandler{ [weak self] commandBuffer in
            if let strongSelf = self {
                dispatch_semaphore_signal(strongSelf.inflightSemaphore)
            }
            return
        }
        
        // bufferIndex matches the current semaphore controled frame index to ensure writing occurs at the correct region in the vertex buffer
        bufferIndex = (bufferIndex + 1) % MaxBuffers
    
        
        commandBuffer.presentDrawable(view.currentDrawable!)

        commandBuffer.commit()

    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    func drawInView(o: MTKView) {
        NSLog("DRAW IN VIEW: \(o)")
//        self.drawInView(o);
    }
}
