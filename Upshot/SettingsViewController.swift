//
//  SettingsViewController.swift
//  Upshot
//
//  Created by Callum Henshall on 05/09/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var urlTextField: NSTextField!
    
    @IBOutlet weak var launchAtLoginButton: NSButton!
    @IBOutlet weak var playSoundButton: NSButton!

    override func viewWillAppear() {
        super.viewWillAppear()
        
        urlTextField.stringValue = SettingsManager.sharedInstance.url
        launchAtLoginButton.state = (SettingsManager.sharedInstance.launchAtLogin ? NSOnState : NSOffState)
        playSoundButton.state = (SettingsManager.sharedInstance.playSound ? NSOnState : NSOffState)
    }
    
}

extension SettingsViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        
        SettingsManager.sharedInstance.url = urlTextField.stringValue
    }
}

extension SettingsViewController {
    
    @IBAction func launchAtLoginChangeAction(_ sender: NSButton) {
        
        SettingsManager.sharedInstance.launchAtLogin = launchAtLoginButton.state == NSOnState
    }
}

extension SettingsViewController {
    
    @IBAction func playSoundChangeButton(_ sender: NSButton) {
        
        SettingsManager.sharedInstance.playSound = playSoundButton.state == NSOnState
    }
}

