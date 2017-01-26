//
//  AppDelegate.swift
//  TextFinder
//
//  Created by Brian Prescott on 11/5/16.
//  Copyright © 2016 Wave 39 LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openTheDocument(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        
        let selection = openPanel.runModal()
        
        if selection == NSModalResponseOK {
            for url in openPanel.urls {
                print ("Path: " + url.absoluteString)
                let controller = DocumentViewController.init(url: url)
                if let window = NSApplication.shared().mainWindow {
                    window.contentViewController = controller
                }
            }
        }
    }
}

