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
    
    class func delete(key: String) {
        
        UserDefaults.standard.removeObject(forKey: key)
    }
}

extension PersistentStore {
    
    class func saveObject(_ object: NSCoding, key: String) {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
        
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func saveObjects(_ objects: [NSCoding], key: String) {
        
        if objects.count > 0 {
            
            var encodedObjects: [Data] = []
            
            for object in objects {
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
                encodedObjects.append(encodedData)
            }
            
            UserDefaults.standard.set(encodedObjects, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getObject<T: NSCoding>(key: String) -> T? {
        
        if let encodedObject = UserDefaults.standard.object(forKey: key) as? Data {
            
            let object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as! T
            
            return object
        }
        return nil
    }
    
    class func getObjects<T: NSCoding>(key: String) -> [T]? {
        
        if let encodedObjects = UserDefaults.standard.object(forKey: key) as? [Data], encodedObjects.count > 0 {
            
            var objects: [T] = []
            
            for encodedData in encodedObjects {
                
                let object = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! T
                objects.append(object)
            }
            return objects
        }
        return nil
    }
    
}

extension PersistentStore {
    
    class func getStandardObject(key: String) -> AnyObject? {
        
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    
    class func saveStandardObject(_ object: AnyObject, key: String) {
        
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension PersistentStore {
    
    class func getString(key: String) -> String? {
        return getStandardObject(key: key) as? String
    }

    class func getInt(key: String) -> Int? {
        return getStandardObject(key: key) as? Int
    }
    
    class func getBool(key: String) -> Bool? {
        return getStandardObject(key: key) as? Bool
    }
    
}

