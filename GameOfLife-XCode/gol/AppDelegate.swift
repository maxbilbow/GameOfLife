//
//  AppDelegate.swift
//  gol
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright (c) 2015 Max Bilbow. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var theApp : AppDelegate?;
    static var window: NSWindow? {
        return theApp?.window
    }
    @IBOutlet weak var window: NSWindow!
    
    override func awakeFromNib() {
        print("Launching")
        AppDelegate.theApp = self;
        
    }
    func applicationWillFinishLaunching(notification: NSNotification) {
        
    }
    func applicationWillBecomeActive(notification: NSNotification) {
        
    }
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
    
}