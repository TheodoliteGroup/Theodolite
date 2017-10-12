//
//  Scope.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public class Scope {
  let component: Component;
  let handle: ScopeHandle;
  let children: [Scope];
  
  /** 
   This is arguably the most complex part of Theodolite. Scopes are an implementation detail of the infrastructure,
   and you should never really have to interact with Scopes if you're working on a Theodolite Component tree.
   
   The core role of scopes is to call render() on each component recursively, and record the children for each
   component. As part of this process of building the component hierarchies, scopes are responsible for matching each
   component with its previous generation, and attaching any prior state, and applying any state updates before calling
   render().
   
   Scopes also keep a reference to the state update listener, and when components call self.updateState(...), they
   actually call through the scope handle to the listener.
   
   One scope is built for each component in the hierarchy.
  */
  init(listener: StateUpdateListener?,
       component: Component,
       previousScope: Scope?,
       stateUpdateMap: [Int32: Any?]) {
    self.component = component;
    // First we have to set up our scope handle before calling render so that the state and state updater are
    // available to the component in render().
    if let prev = previousScope {
      self.handle = ScopeHandle(
        identifier: prev.handle.identifier,
        state: stateUpdateMap[prev.handle.identifier]
          ?? prev.handle.state) {
            [weak listener] (identifier: Int32, value: Any?) in
            listener?.receivedStateUpdate(identifier: identifier,
                                          update: value);
      }
    } else {
      let typed = component as? InternalTypedComponent;
      self.handle = ScopeHandle(state:typed?.initialUntypedState()) {
        [weak listener](identifier: Int32, state: Any?) -> () in
        listener?.receivedStateUpdate(identifier: identifier, update: state);
      }
    }
    setScopeHandle(component: component, handle: self.handle);
    
    // We're now able to call render, since we've finished setting up the scope handle and state update listener.
    self.children = (component.render() ?? []).map { (child) -> Scope in
      // Note this is inefficient if there are a large number of children. We're assuming the number of children is
      // small to begin with, and can convert to a hash map if we add more.
      let prev = previousScope?.children.first(where: { (s: Scope) -> Bool in
        return areComponentsEquivalent(c1: child, c2: s.component);
      })
      return Scope(listener: listener,
                   component: child,
                   previousScope: prev,
                   stateUpdateMap: stateUpdateMap);
    }
  }
}

internal func areComponentsEquivalent(c1: Component, c2: Component) -> Bool {
  return type(of: c1) == type(of: c2)
    && c1.key() == c2.key();
}
