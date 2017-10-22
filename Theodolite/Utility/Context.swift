//
//  Context.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/22/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public class Context<T> {
  let value: T?
  private var hasCleanedUp = false
  
  init(val: T, key: AnyHashable = Metatype(T.self)) {
    value = val
  }
  
  init(key: AnyHashable = Metatype(T.self)) {
    value = Stack.get(key: key) as? T
    assert(value != nil)
  }
  
  deinit {
    assert(hasCleanedUp)
  }
  
  class Stack {
    var stack: [[AnyHashable: Any]] = []
    
    static func get(key: AnyHashable) -> Any? {
      if let currentStack = Thread.current.threadDictionary.object(forKey: kStackKey) as? Stack {
        return currentStack.stack.last?[key]
      }
      return nil
    }
    
    static func push() {
      if let currentStack = Thread.current.threadDictionary.object(forKey: kStackKey) as? Stack {
        currentStack.stack.append([:])
      } else {
        let stack = Stack()
        stack.stack.append([:])
        Thread.current.threadDictionary[kStackKey] = stack
      }
    }
    
    static func pop() {
      if let currentStack: Stack = Thread.current.threadDictionary.object(forKey: kStackKey) as? Stack {
        if currentStack.stack.count == 1 {
          Thread.current.threadDictionary.removeObject(forKey: kStackKey)
        } else {
          currentStack.stack.removeLast()
        }
      } else {
        assertionFailure()
      }
    }
  }
}

private let kStackKey = "theodolite-ComponentContextStack"

/// Hashable wrapper for a metatype value.
struct Metatype<T> : Hashable {
  let base: T.Type
  
  init(_ base: T.Type) {
    self.base = base
  }
  
  static func ==(lhs: Metatype, rhs: Metatype) -> Bool {
    return lhs.base == rhs.base
  }
  
  var hashValue: Int {
    return ObjectIdentifier(base).hashValue
  }
}
