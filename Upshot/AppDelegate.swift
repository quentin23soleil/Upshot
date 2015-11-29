
//
//  AppDelegate.swift
//  Upshot
//
//  Created by Quentin Dommerc on 16/07/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMetadataQueryDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    var monitor : Monitor!
    let statusBarManager = StatusBarItemManager()
    
    let settingsWindowController = Storyboards.Main.instantiateSettingsWindowController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        quitIfAlreadyRunning()
        
        defaults.registerDefaults(["NSApplicationCrashOnExceptions": true])
        
        monitor = Monitor(callback: screenshotDetected)
        monitor.startMonitoring()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        
        monitor?.stopMonitoring()
    }
}

extension AppDelegate {
    
    func quitIfAlreadyRunning() {
        if NSRunningApplication.runningApplicationsWithBundleIdentifier(NSBundle.mainBundle().bundleIdentifier!).count > 1 {
            
            let appName = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as! String
            let alert = NSAlert()
            alert.messageText = "An instance of \(appName) is already running"
            alert.runModal()
            NSApp.terminate(nil)
        }
    }
}

extension AppDelegate {
    
    func screenshotDetected(imageURL: NSURL) {
        statusBarManager.sending()
        
        let uploader = Uploader(file: imageURL)
        uploader.upload(screenshotUploadSuccess, errorCallback: screenshotUploadFailure)
    }
    
    func screenshotUploadSuccess(url : String) {
        
        if SettingsManager.sharedInstance.playSound {
            
            let sound = NSSound(named: "success")
            
            sound!.play()
        }
        
        statusBarManager.success()
        ClipboardManager().save(url)
    }
    
    func screenshotUploadFailure() {
        
        statusBarManager.failure()
        ClipboardManager().save("")
    }
}

extension AppDelegate {
    
    func showSettingsWindow() {
        
        NSApp.activateIgnoringOtherApps(true)

        settingsWindowController.window?.center()
        settingsWindowController.showWindow(nil)
    }
}

extension NSApplication {
    
    var appDelegate: AppDelegate {
        return delegate as! AppDelegate
    }
}
