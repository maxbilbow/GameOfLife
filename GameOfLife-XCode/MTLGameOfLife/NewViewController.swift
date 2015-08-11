//
//  ViewController.swift
//  HelloMetal
//
//  Created by Main Account on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import MetalKit
import QuartzCore
let MaxBuffers = 2
//let ConstantBufferSize = 1024*1024

class GameViewController: NSViewController, MTKViewDelegate {
    let inflightSemaphore = dispatch_semaphore_create(MaxBuffers)
    let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    var metalLayer: CAMetalLayer! = nil
    lazy var objectToDraw: Shape = Shape.Cube
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
//    var timer: CADisplayLink! =
//    var vertexBuffer: MTLBuffer! = nil
    var projectionMatrix: Matrix4!
    var lastFrameTimestamp: CFTimeInterval = 0.0
    var bufferIndex = 0
    lazy var shapes: [Shape] = [Shape.Square]
    static var current: GameViewController!
    
    
    override func viewDidLoad() {
        GameViewController.current = self
        super.viewDidLoad()
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
//        view.sampleCount = 1
        self.projectionMatrix = Matrix4.makePerspectiveViewAngle(degrees: 85.0, aspect: Float(view.bounds.size.width / view.bounds.size.height), nearZ: 0.01, farZ: 2000.0)
        
        loadAssets()

        
    }
   
    func loadAssets() {
        
        let view = self.view as! MTKView
        
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = view.colorPixelFormat//.BGRA8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer!.frame  // 5
        view.layer?.addSublayer(metalLayer)   // 6
        
        objectToDraw = Shape.Cube
        
        commandQueue = device.newCommandQueue()
        commandQueue.label = "main command queue"
        
        // 1
        let defaultLibrary = device.newDefaultLibrary()!
        let fragmentProgram = defaultLibrary.newFunctionWithName("basic_fragment")!
        let vertexProgram = defaultLibrary.newFunctionWithName("basic_vertex")!
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineStateDescriptor.sampleCount = view.sampleCount
        
        // 3
        do {
            pipelineState = try device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            print("Failed to create pipeline state, error \(error)")
        }
        
        //        timer = CADisplayLink(target: self, selector: Selector("newFrame:"))
        //        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func drawInMTKView(view: MTKView) {
        self.newFrame(1/60)
    }
    
    func render() {
//
        dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER)
        let drawable = metalLayer.nextDrawable()!
        
        var worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)
        worldModelMatrix.rotateAbout(dx: 25)

        let commandBuffer = self.objectToDraw.render(self.commandQueue,
            pipelineState: self.pipelineState,
            drawable: drawable,
            parentModelViewMatrix: worldModelMatrix,
            projectionMatrix: projectionMatrix.raw(),
            clearColor: nil
        )
        
        commandBuffer.addCompletedHandler{ [weak self] commandBuffer in
            if let strongSelf = self {
                dispatch_semaphore_signal(strongSelf.inflightSemaphore)
            }
            return
        }
        // bufferIndex matches the current semaphore controled frame index to ensure writing occurs at the correct region in the vertex buffer
        bufferIndex = (bufferIndex + 1) % MaxBuffers
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()

        
//
        
        
        
//        commandBuffer.presentDrawable((self.view as! MTKView).currentDrawable!)
////
//        commandBuffer.commit()

    }
    
    // 1
    func newFrame(displayLinkTimestamp: CFTimeInterval){
        
        if lastFrameTimestamp == 0.0
        {
            lastFrameTimestamp = displayLinkTimestamp
        }
        
        // 2
        let elapsed:CFTimeInterval = displayLinkTimestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLinkTimestamp
        
        // 3
        gameloop(timeSinceLastUpdate: elapsed)
    }
    
    func gameloop(timeSinceLastUpdate timeSinceLastUpdate: CFTimeInterval) {
        
        // 4
        objectToDraw.updateWithDelta(timeSinceLastUpdate)
            GameScene.current.update(timeSinceLastUpdate)
        // 5
        autoreleasepool {

            self.render()
            
        }
    }
    
}

