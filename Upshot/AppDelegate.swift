
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

    let defaults = UserDefaults.standard
    var monitor : Monitor!
    let statusBarManager = StatusBarItemManager()
    
    let settingsWindowController = Storyboards.Main.instantiateSettingsWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        quitIfAlreadyRunning()
        
        defaults.register(defaults: ["NSApplicationCrashOnExceptions": true])
        
        monitor = Monitor(callback: screenshotDetected)
        monitor.startMonitoring()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        monitor?.stopMonitoring()
    }
}

extension AppDelegate {
    
    func quitIfAlreadyRunning() {
        if NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier!).count > 1 {
            
            let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
            let alert = NSAlert()
            alert.messageText = "An instance of \(appName) is already running"
            alert.runModal()
            NSApp.terminate(nil)
        }
    }
}

extension AppDelegate {
    
    func screenshotDetected(_ imageURL: URL) {
        
        upload(imageURL)
    }
}

extension AppDelegate {
    
    func upload(_ fileURL: URL) {
        
        statusBarManager.sending()
        
        let uploader = Uploader(file: fileURL)
        uploader.upload(callback: uploadFinished)
    }
    
    func uploadFinished(_ response: Uploader.Response) {
        
        switch response {
        case .success(let urlString):
            if SettingsManager.sharedInstance.playSound {
                
                let sound = NSSound(named: "success")
                
                sound!.play()
            }
            
            statusBarManager.success()
            ClipboardManager().save(urlString)
            
        case .failure:
            statusBarManager.failure()
            ClipboardManager().save("")
        }
    }
}

extension AppDelegate {
    
    func showSettingsWindow() {
        
        NSApp.activate(ignoringOtherApps: true)

        settingsWindowController.window?.center()
        settingsWindowController.showWindow(nil)
    }
}

extension NSApplication {
    
    var appDelegate: AppDelegate {
        return delegate as! AppDelegate
    }
}

