//
//  SettingsManager.swift
//  Upshot
//
//  Created by Callum Henshall on 05/09/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static let sharedInstance = SettingsManager()
    
    var url: String {
        didSet {
            PersistentStore.saveStandardObject(url as AnyObject, key: Key.URL)
        }
    }
    
    var launchAtLogin: Bool {
        didSet {
            PersistentStore.saveStandardObject(launchAtLogin as AnyObject, key: Key.LaunchAtLogin)
            if launchAtLogin {
                LaunchManager.launchAtStartUp()
            }
            else {
                LaunchManager.removeLaunchAtStartUp()
            }
        }
    }
    
    var playSound: Bool {
        didSet {
            PersistentStore.saveStandardObject(playSound as AnyObject, key: Key.PlaySound)
        }
    }
    
    fileprivate struct Key {
        
        static let URL = "URLKey"
        static let LaunchAtLogin = "LaunchAtLoginKey"
        static let PlaySound = "PlaySoundKey"
    }
    
    init() {
        
        url = PersistentStore.getString(key: Key.URL) ?? ""
        launchAtLogin = PersistentStore.getBool(key: Key.LaunchAtLogin) ?? false
        playSound = PersistentStore.getBool(key: Key.PlaySound) ?? true
    }
}

