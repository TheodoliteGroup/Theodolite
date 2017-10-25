//
//  ScopeHandle.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 When a component is found to be completely new, it is assigned a simple integer which is monotonically increasing.
 
 This lets us centralize the identifier comparison code into a single callsite inside Scope itself, and everyone else
 can just use an integer for rapid comparisons and lookups by component.
 
 You can think about a scope handle's identifier as the *result* of the identification operation. Note this is global
 to the entire app.
 */
var __currentIdentifier: Atomic<Int32> = Atomic<Int32>(0)

/**
 Internal bag of data that contains the information that the framework associates with a given logical component
 through its generations.
 */
public class ScopeHandle {
  let identifier: Int32
  let state: Any?
  let stateUpdater: (Int32, Any?) -> ()
  
  convenience init(state: Any?, stateUpdater: @escaping (Int32, Any?) -> ()) {
    self.init(identifier: __currentIdentifier.update({ (val: Int32) -> Int32 in
      return val + 1
    }), state: state, stateUpdater: stateUpdater)
  }
  
  init(identifier: Int32, state: Any?, stateUpdater: @escaping (Int32, Any?) -> ()) {
    self.identifier = identifier
    self.state = state
    self.stateUpdater = stateUpdater
  }
}

var kScopeHandleKey: Void?

internal func setScopeHandle(component: Component, handle: ScopeHandle) {
  setAssociatedObject(object: component, value: handle, associativeKey: &kScopeHandleKey)
}

internal func getScopeHandle(component: Component) -> ScopeHandle? {
  return getAssociatedObject(object: component, associativeKey: &kScopeHandleKey)
}
