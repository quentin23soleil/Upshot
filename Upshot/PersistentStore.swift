//
//  PersistentStore.swift
//  Upshot
//
//  Created by Callum Henshall on 05/09/15.
//  Copyright © 2015 Quentin Dommerc. All rights reserved.
//

import Foundation

class PersistentStore {
    
}

extension PersistentStore {
    
    class func delete(key key: String) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
}

extension PersistentStore {
    
    class func saveObject(object: NSCoding, key: String) {
        
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(object)
        
        NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func saveObjects(objects: [NSCoding], key: String) {
        
        if objects.count > 0 {
            
            var encodedObjects: [NSData] = []
            
            for object in objects {
                
                let encodedData = NSKeyedArchiver.archivedDataWithRootObject(object)
                encodedObjects.append(encodedData)
            }
            
            NSUserDefaults.standardUserDefaults().setObject(encodedObjects, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func getObject<T: NSCoding>(key key: String) -> T? {
        
        if let encodedObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as! T
            
            return object
        }
        return nil
    }
    
    class func getObjects<T: NSCoding>(key key: String) -> [T]? {
        
        if let encodedObjects = NSUserDefaults.standardUserDefaults().objectForKey(key) as? [NSData] where encodedObjects.count > 0 {
            
            var objects: [T] = []
            
            for encodedData in encodedObjects {
                
                let object = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as! T
                objects.append(object)
            }
            return objects
        }
        return nil
    }
    
}

extension PersistentStore {
    
    class func getStandardObject(key key: String) -> AnyObject? {
        
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func saveStandardObject(object: AnyObject, key: String) {
        
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension PersistentStore {
    
    class func getString(key key: String) -> String? {
        return getStandardObject(key: key) as? String
    }

    class func getInt(key key: String) -> Int? {
        return getStandardObject(key: key) as? Int
    }
    
    class func getBool(key key: String) -> Bool? {
        return getStandardObject(key: key) as? Bool
    }
    
}

