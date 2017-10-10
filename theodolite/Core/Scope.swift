//
//  Scope.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

protocol StateUpdateListener: class {
  func receivedStateUpdate(identifier: Int32, update: Any?);
}

public class ScopeRoot {
  let root: Scope;
  weak var listener: StateUpdateListener?;
  
  init(previousRoot: ScopeRoot?, listener: StateUpdateListener, stateUpdateMap: [Int32: Any?], factory: () -> Component) {
    self.listener = listener;
    self.root = Scope(listener: listener,
                      component: factory(),
                      previousScope: previousRoot?.root,
                      stateUpdateMap: stateUpdateMap);
  }
}

var __currentIdentifier: Atomic<Int32> = Atomic<Int32>(0);

public class ScopeHandle {
  let identifier: Int32;
  let state: Any?;
  let stateUpdater: (Int32, Any?) -> ();
  
  convenience init(state: Any?, stateUpdater: @escaping (Int32, Any?) -> ()) {
    self.init(identifier: __currentIdentifier.update({ (val: Int32) -> Int32 in
      return val + 1;
    }), state: state, stateUpdater: stateUpdater);
  }
  
  init(identifier: Int32, state: Any?, stateUpdater: @escaping (Int32, Any?) -> ()) {
    self.identifier = identifier;
    self.state = state;
    self.stateUpdater = stateUpdater;
  }
}

public class Scope {
  let component: Component;
  let handle: ScopeHandle;
  let children: [Scope];
  
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
          ?? prev.handle.state) { [weak listener] (identifier: Int32, value: Any?) in
            listener?.receivedStateUpdate(identifier: identifier, update: value);
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
        return type(of: child) == type(of: s.component)
          && child.key() == s.component.key();
      })
      return Scope(listener: listener,
                   component: child,
                   previousScope: prev,
                   stateUpdateMap: stateUpdateMap);
    }
  }
  
  func iterate(iterator: (Component, inout Bool) -> Void) {
    var stop = false;
    iterator(self.component, &stop)
    if stop {
      return;
    }
    for childScope in self.children {
      childScope.iterate(iterator: iterator);
    }
  }
}

var kScopeHandleKey: Void?;

internal func setScopeHandle(component: Component, handle: ScopeHandle) {
  setAssociatedObject(object: component, value: handle, associativeKey: &kScopeHandleKey);
}

internal func getScopeHandle(component: Component) -> ScopeHandle? {
  return getAssociatedObject(object: component, associativeKey: &kScopeHandleKey);
}
