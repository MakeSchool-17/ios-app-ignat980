//
//  Extenstions.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 1/8/16.
//  Copyright © 2016 Ignat Remizov. All rights reserved.
//

import Foundation


extension NSObject {
    /// Returns the value for the derived property identified by a given key path, with indexes.
    ///
    /// :params: keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
    func valueForKeyPathWithIndexes(keyPath: String) -> NSObject {
        if keyPath.containsString("[") {
            let parts = keyPath.componentsSeparatedByString(".")
            var currentObj = self
            for (var i = 0;i < parts.count; i++) {
                if parts[i].containsString("[") {
                    if let index = Int(parts[i].substringToIndex(parts[i].endIndex.predecessor()).substringFromIndex(parts[i].startIndex.successor())){
                        currentObj = (currentObj as! NSArray).objectAtIndex(index) as! NSObject
                    } else {
                        print("The value between the [] in the key path is not an integer")
                    }
                } else {
                    currentObj = currentObj.valueForKey(parts[i]) as! NSObject
                }
            }
            return currentObj
        } else {
            return self.valueForKeyPath(keyPath) as! NSObject
        }
    }
}

extension Array {
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}

extension NSRange {
    
    init(location: Int, length: Int) {
        self.location = location
        self.length = length
    }
    
    init(_ location: Int, _ length: Int) {
        self.location = location
        self.length = length
    }
    
    init(range: Range<Int>) {
        self.location = range.startIndex
        self.length = range.endIndex - range.startIndex
    }
    
    var startIndex: Int {
        return location
    }
    
    var endIndex: Int {
        return location + length
    }
    
    var asRange: Range<Int> {
        return location..<location + length
    }
    
    var isEmpty: Bool {
        return length == 0
    }
}

extension Range where Element:SignedIntegerType  {
    var asNSRange: NSRange {
        get {
            if Element(0) is Int {
                return NSRange(location: startIndex as! Int, length: (endIndex as! Int) - (startIndex as! Int))
            } else {
                raise(404)
                return NSRange(location: 0, length: 0)
            }
        }
    }
}

extension NSAttributedString {
    subscript (range: NSRange) -> NSAttributedString {
        get {
            assert(range.location < length, "Index out of range")
            return attributedSubstringFromRange(range)
        }
    }
}

extension NSMutableAttributedString {
    
    override subscript (range: NSRange) -> NSMutableAttributedString {
        get {
            assert(range.location < length, "Index out of range")
            return NSMutableAttributedString(attributedString: super[range])
        }
        
        set {
            insertAttributedString(newValue, atIndex: range.location)
        }
    }
    
    subscript (range: Range<Int>) -> NSMutableAttributedString {
        get {
            assert(range.startIndex < length, "Index out of range")
            return NSMutableAttributedString(attributedString: super[NSRange(range)])
        }
        
        set {
            if range.startIndex >= length {
                appendAttributedString(newValue)
            } else {
                insertAttributedString(newValue, atIndex: range.startIndex)
            }
        }
    }
    
    subscript (index: Int, length: Int) -> NSMutableAttributedString {
        get {
            assert(index < length, "Index out of range")
            return NSMutableAttributedString(attributedString: super[NSRange(location: index, length: length)])
        }
        
        set {
            insertAttributedString(newValue, atIndex: index)
        }
    }
}


infix operator » {}
postfix operator ~ {}

///Returns a Random Element from the array
postfix func ~<T> (array: Array<T>) -> T {
    return array.randomElement()
}

func » (attributedString: NSMutableAttributedString, index: Int) -> [String:AnyObject] {
    assert(index >= 0 && index < attributedString.length, "Index '\(index)' out of bounds")
    return attributedString.attributesAtIndex(index, effectiveRange: nil)
}

func » (attributedString: NSAttributedString, index: Int) -> [String:AnyObject] {
    assert(index >= 0 && index < attributedString.length, "Index '\(index)' out of bounds")
    return attributedString.attributesAtIndex(index, effectiveRange: nil)
}

func + (leftString: NSMutableAttributedString, rightString: NSMutableAttributedString) -> NSMutableAttributedString {
    let copy = leftString.mutableCopy() as! NSMutableAttributedString
    copy.appendAttributedString(rightString)
    return copy
}

func + (leftString: NSAttributedString, rightString: NSMutableAttributedString) -> NSMutableAttributedString {
    let copy = leftString.mutableCopy() as! NSMutableAttributedString
    copy.appendAttributedString(rightString)
    return copy
}

func + (leftString: NSMutableAttributedString, rightString: NSAttributedString) -> NSMutableAttributedString {
    let copy = leftString.mutableCopy() as! NSMutableAttributedString
    copy.appendAttributedString(rightString)
    return copy
}

func + (attributedString: NSMutableAttributedString, str: String) -> NSMutableAttributedString {
    let copy = attributedString.mutableCopy() as! NSMutableAttributedString
    copy.appendAttributedString(NSAttributedString(string: str, attributes:attributedString.attributesAtIndex(attributedString.length.predecessor(), effectiveRange: nil)))
    return copy
}

func + (str: String, attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
    let new = NSMutableAttributedString(string: str, attributes:attributedString.attributesAtIndex(0, effectiveRange: nil))
    new.appendAttributedString(attributedString)
    return new
}

func + (attributedString: NSAttributedString, str: String) -> NSMutableAttributedString {
    let copy = attributedString.mutableCopy() as! NSMutableAttributedString
    copy.appendAttributedString(NSAttributedString(string: str, attributes:attributedString.attributesAtIndex(attributedString.length.predecessor(), effectiveRange: nil)))
    return copy
}

func + (str: String, attributedString: NSAttributedString) -> NSMutableAttributedString {
    let new = NSMutableAttributedString(string: str, attributes:attributedString.attributesAtIndex(0, effectiveRange: nil))
    new.appendAttributedString(attributedString)
    return new
}

func + <K, V>(left: [K:V], right: [K:V]) -> [K:V] {
    var copy = left
    for (k, v) in right {
        copy[k] = v
    }
    return copy
}

