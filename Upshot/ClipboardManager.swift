//
//  ClipboardManager.swift
//  Upshot
//
//  Created by Quentin Dommerc on 17/07/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation
import AppKit


class ClipboardManager {
    
    var pasteBoard : NSPasteboard
    
    init () {
        pasteBoard = NSPasteboard.generalPasteboard()

    }
    
    func save(str : String) -> Void {
        pasteBoard.clearContents()
        pasteBoard.setString(str, forType: NSPasteboardTypeString)
    }
}