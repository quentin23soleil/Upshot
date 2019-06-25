//
//  Storyboards.swift
//  Upshot
//
//  Created by Cédric Eugeni on 25/06/2019.
//  Copyright © 2019 Cédric Eugeni. All rights reserved.
//

import Foundation

import Cocoa

//MARK: - Storyboards
struct Storyboards {
    
    struct Main {
        
        static let identifier = "Main"
        
        static var storyboard: NSStoryboard {
            return NSStoryboard(name: self.identifier, bundle: nil)
        }
        
        static func instantiateWindowControllerWithIdentifier(_ identifier: String) -> NSWindowController {
            return self.storyboard.instantiateController(withIdentifier: identifier) as! NSWindowController
        }
        
        static func instantiateViewControllerWithIdentifier(_ identifier: String) -> NSViewController {
            return self.storyboard.instantiateController(withIdentifier: identifier) as! NSViewController
        }
        
        static func instantiateSettingsWindowController() -> SettingsWindowController {
            return self.storyboard.instantiateController(withIdentifier: "SettingsWindowController") as! SettingsWindowController
        }
    }
}

//MARK: - ReusableKind
enum ReusableKind: String, CustomStringConvertible {
    case TableViewCell = "tableViewCell"
    case CollectionViewCell = "collectionViewCell"
    
    var description: String { return self.rawValue }
}

//MARK: - SegueKind
enum SegueKind: String, CustomStringConvertible {
    case Relationship = "relationship"
    case Show = "show"
    case Presentation = "presentation"
    case Embed = "embed"
    case Unwind = "unwind"
    case Push = "push"
    case Modal = "modal"
    case Popover = "popover"
    case Replace = "replace"
    case Custom = "custom"
    
    var description: String { return self.rawValue }
}

//MARK: - SegueProtocol
public protocol IdentifiableProtocol: Equatable {
    var identifier: String? { get }
}

public protocol SegueProtocol: IdentifiableProtocol {
}

public func ==<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ~=<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ==<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ~=<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ==<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

public func ~=<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

//MARK: - ReusableViewProtocol
public protocol ReusableViewProtocol: IdentifiableProtocol {
    var viewType: NSView.Type? { get }
}

public func ==<T: ReusableViewProtocol, U: ReusableViewProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: - Protocol Implementation
extension NSStoryboardSegue: SegueProtocol {
}

//MARK: - NSViewController extension
extension NSViewController {
    func performSegue<T: SegueProtocol>(_ segue: T, sender: AnyObject?) {
        if let identifier = segue.identifier {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func performSegue<T: SegueProtocol>(_ segue: T) {
        performSegue(segue, sender: nil)
    }
}

//MARK: - NSWindowController extension
extension NSWindowController {
    func performSegue<T: SegueProtocol>(_ segue: T, sender: AnyObject?) {
        if let identifier = segue.identifier {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func performSegue<T: SegueProtocol>(_ segue: T) {
        performSegue(segue, sender: nil)
    }
}


//MARK: - SettingsWindowController

//MARK: - SettingsViewController
