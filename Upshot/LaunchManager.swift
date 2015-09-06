//
//  LaunchManager.swift
//  Upshot
//
//  Created by Callum Henshall on 06/09/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation

class LaunchManager {
    
    class func launchAtStartUp() {
        
        guard launchAtStartUpScriptExists() == false else {
            return
        }
        
        let path = pathForScript()
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        
        let dict: NSDictionary = [
            "Label": bundleID,
            "Program": "/Applications/Upshot.app/Contents/MacOS/Upshot",
            "RunAtLoad": true
        ]
        
        dict.writeToFile(path, atomically: false)
    }
    
    class func removeLaunchAtStartUp() {
        
        if launchAtStartUpScriptExists(), let path = pathForScript() {
            
            let fileManager = NSFileManager.defaultManager()
            
            try! fileManager.removeItemAtPath(path)
        }
    }
    
    private class func pathForScript() -> String! {
        
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.LibraryDirectory,
            NSSearchPathDomainMask.UserDomainMask,
            true
        )
        
        if let path = paths.first, bundleID = NSBundle.mainBundle().bundleIdentifier {
            
            return (path as NSString).stringByAppendingPathComponent("LaunchAgents/\(bundleID).plist")
        }
        
        return nil
    }
    
    class func launchAtStartUpScriptExists() -> Bool {
        
        let fileManager = NSFileManager.defaultManager()
        
        if let path = pathForScript() where fileManager.fileExistsAtPath(path) {
            return true
        }
        return false
    }
}