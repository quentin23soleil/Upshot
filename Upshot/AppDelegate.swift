//
//  AppDelegate.swift
//  Upshot
//
//  Created by Quentin Dommerc on 16/07/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMetadataQueryDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    var monitor : Monitor!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        defaults.registerDefaults(["NSApplicationCrashOnExceptions": true])


        
        monitor = Monitor(callback: screenshotDetected)
        monitor.startMonitoring()
    }
    
    
    func screenshotDetected(imageURL: NSURL) {
        let uploader = Uploader(file: imageURL)
        uploader.upload()
    }


    func applicationWillTerminate(aNotification: NSNotification) {
    }
}

