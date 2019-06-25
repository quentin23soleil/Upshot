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
        let bundleID = Bundle.main.bundleIdentifier!
        
        let dict: NSDictionary = [
            "Label": bundleID,
            "Program": "/Applications/Upshot.app/Contents/MacOS/Upshot",
            "RunAtLoad": true
        ]
        
        dict.write(toFile: path!, atomically: false)
    }
    
    class func removeLaunchAtStartUp() {
        
        if launchAtStartUpScriptExists(), let path = pathForScript() {
            
            let fileManager = FileManager.default
            
            try! fileManager.removeItem(atPath: path)
        }
    }
    
    fileprivate class func pathForScript() -> String! {
        
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.libraryDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true
        )
        
        if let path = paths.first, let bundleID = Bundle.main.bundleIdentifier {
            
            return (path as NSString).appendingPathComponent("LaunchAgents/\(bundleID).plist")
        }
        
        return nil
    }
    
    class func launchAtStartUpScriptExists() -> Bool {
        
        let fileManager = FileManager.default
        
        if let path = pathForScript(), fileManager.fileExists(atPath: path) {
            return true
        }
        return false
    }
}

