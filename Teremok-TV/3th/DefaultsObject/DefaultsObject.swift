//
//  DefaultsObject.swift
//  RZD
//
//  Created by Mikhail Tishin on 25/05/16.
//  Copyright © 2016 tt. All rights reserved.
//

import Foundation

@objcMembers class DefaultsObject: NSObject {
    
    static var objectDictionary: [String: AnyObject] = [:]
    
    func saveToDefaults() {
        let className = String(describing: type(of: self))
        let defaults = UserDefaults.standard
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        defaults.set(encodedObject, forKey: className)
        defaults.synchronize()
        DefaultsObject.objectDictionary[className] = self
    }
    
    static func fromDefaults() -> Self {
        return fromDefaults(self)
    }
    
    fileprivate static func fromDefaults<T>(_ type: T.Type) -> T where T: NSObject {
        let className = String(describing: T.self)
        if let object = objectDictionary[className] as? T {
            return object
        } else {
            if let encodedObject = UserDefaults.standard.object(forKey: className) as? Data,
                let object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? T {
                objectDictionary[className] = object
                return object
            } else {
                let object = T()
                objectDictionary[className] = object
                (object as! DefaultsObject).saveToDefaults()
                return object
            }
        }
    }
    
    // MARK: - NSCoding
    
    @objc func encodeWithCoder(_ aCoder: NSCoder) {
        var baseMirror: Mirror? = Mirror(reflecting: self)
        
        while let mirror = baseMirror {
            for child in mirror.children {
                if let label = child.label {
                    aCoder.encode(self.value(forKey: label), forKey: label)
                }
            }
            baseMirror = mirror.superclassMirror
        }
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        var baseMirror: Mirror? = Mirror(reflecting: self)
        
        while let mirror = baseMirror {
            for child in mirror.children {
                if let label = child.label {
                    if aDecoder.containsValue(forKey: label) {
                        do {
                            let value = aDecoder.decodeObject(forKey: label)
                            if let value = value {
                                var objectValue = value as AnyObject?
                                try validateValue(&objectValue, forKey: label)
                            }
                            setValue(value, forKey: label)
                        } catch {
                        }
                    }
                }
            }
            baseMirror = mirror.superclassMirror
        }
    }
    
}
