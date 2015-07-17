//
//  Monitor.swift
//  Upshot
//
//  Created by Quentin Dommerc on 17/07/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation

class Monitor {
    
    let callback: NSURL -> Void
    var query: NSMetadataQuery
    var blacklist: [String]
    
    init(callback: NSURL -> Void) {
        self.callback = callback
        self.blacklist = []
        
        query = NSMetadataQuery()
        
        query.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1")
    }
    
    func startMonitoring() {
        NSNotificationCenter.defaultCenter().addObserverForName(NSMetadataQueryDidFinishGatheringNotification, object: query, queue: nil, usingBlock: initialPhaseComplete)
        NSNotificationCenter.defaultCenter().addObserverForName(NSMetadataQueryDidUpdateNotification, object: query, queue: nil, usingBlock: liveUpdatePhaseEvent)
        query.startQuery()
    }
    
    func stopMonitoring() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSMetadataQueryDidFinishGatheringNotification, object: query)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSMetadataQueryDidUpdateNotification, object: query)
        query.stopQuery()
    }
    
    func initialPhaseComplete(notification: NSNotification) {
        // Blacklist all screenshots that already exist
        if let itemsAdded = notification.object?.results as? [NSMetadataItem] {
            for item in itemsAdded {
                // Get the path to the screenshot
                if let screenshotPath = item.valueForAttribute(NSMetadataItemPathKey) as? String {
                    let screenshotName = screenshotPath.lastPathComponent.stringByDeletingPathExtension
                    
                    // Blacklist the screenshot if it hasn't already been blacklisted
                    if !blacklist.contains(screenshotName) {
                        blacklist.append(screenshotName)
                    }
                }
            }
        }
    }
    
    func liveUpdatePhaseEvent(notification: NSNotification) {
        if let itemsAdded = notification.userInfo?["kMDQueryUpdateAddedItems"] as? [NSMetadataItem] {
            for item in itemsAdded {
                // Get the path to the screenshot
                if let path = item.valueForAttribute(NSMetadataItemPathKey) as? String,
                    let creationDate = item.valueForAttribute(NSMetadataItemFSCreationDateKey) as? NSDate {
                        let screenshotName = path.lastPathComponent.stringByDeletingPathExtension
                        
                        let oldestAllowedCreationDate = NSDate(timeIntervalSinceNow: -30) // 30 seconds ago
                        let defaultScreenshotDirectoryPath = path.stringByDeletingLastPathComponent.stringByStandardizingPath
                        let currentScreenshotDirectoryPath = screenshotDirectoryPath.stringByStandardizingPath
                        
                        let isInScreenshotFolder = currentScreenshotDirectoryPath == defaultScreenshotDirectoryPath
                        let isRecentlyCreated = creationDate.compare(oldestAllowedCreationDate) == .OrderedDescending
                        let isBlacklisted = blacklist.contains(screenshotName)
                        
                        // Ensure that the screenshot detected is from the right folder and isn't blacklisted
                        if isRecentlyCreated && isInScreenshotFolder && !isBlacklisted {
                            callback(NSURL(fileURLWithPath: path))
                            blacklist.append(screenshotName)
                        }
                }
            }
        }
    }
    
    var screenshotDirectoryPath: String {
        // Check for custom screenshot location chosen by user
        if let customLocation = NSUserDefaults.standardUserDefaults().persistentDomainForName("com.apple.screencapture")?["location"] as? String {
            // Check that the chosen directory exists, otherwise screencapture will not use it
            var isDir = ObjCBool(false)
            if NSFileManager.defaultManager().fileExistsAtPath(customLocation, isDirectory: &isDir) && isDir {
                return customLocation
            }
        }
        // If a custom location is not defined (or invalid) return the default screenshot location (~/Desktop)
        return NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .UserDomainMask, true)[0]
    }
}