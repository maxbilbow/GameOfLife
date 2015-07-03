//
//  AppDelegate.swift
//  GameOfLife
//
//  Created by Max Bilbow on 03/07/2015.
//  Copyright (c) 2015 Rattle Media. All rights reserved.
//


import Cocoa
import SpriteKit

typealias RMFloat = CGFloat
typealias RMColor = NSColor

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.setLife()
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = false
            self.skView!.showsNodeCount = false
            self.skView.scene?.backgroundColor = NSColor.blackColor()
            
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

extension GameScene {
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        if let node = nodeAtPoint(location).parent as? GameOfLifeNode ?? nodeAtPoint(location) as? GameOfLifeNode {
            self.reviveNodeAndNeighbours(node)
        }
        
        
    }
    
}