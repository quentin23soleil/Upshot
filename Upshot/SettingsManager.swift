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
            PersistentStore.saveStandardObject(url, key: Key.URL)
        }
    }
    
    var launchAtLogin: Bool {
        didSet {
            PersistentStore.saveStandardObject(launchAtLogin, key: Key.LaunchAtLogin)
        }
    }
    
    var playSound: Bool {
        didSet {
            PersistentStore.saveStandardObject(playSound, key: Key.PlaySound)
        }
    }
    
    private struct Key {
        
        static let URL = "URLKey"
        static let LaunchAtLogin = "LaunchAtLoginKey"
        static let PlaySound = "PlaySoundKey"
    }
    
    init() {
        
        url = PersistentStore.getString(key: Key.URL) ?? "http://quentin-dommerc.com/scrup/recv.php?name=%%%filename%%%"
        launchAtLogin = PersistentStore.getBool(key: Key.LaunchAtLogin) ?? false
        playSound = PersistentStore.getBool(key: Key.PlaySound) ?? true
    }
}