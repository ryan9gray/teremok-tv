//
//  Stack.swift
//  Teremok-TV
//
//  Created by R9G on 01/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
    public mutating func toEmpty() {
        return array.removeAll()
    }
    
}
