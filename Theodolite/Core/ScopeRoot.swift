//
//  ScopeRoot.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

protocol StateUpdateListener: class {
  func receivedStateUpdate(identifier: Int32, update: Any?);
}

public class ScopeRoot {
  let root: Scope;
  weak var listener: StateUpdateListener?;
  
  init(previousRoot: ScopeRoot?, listener: StateUpdateListener?, stateUpdateMap: [Int32: Any?], factory: () -> Component) {
    self.listener = listener;
    let component = factory();
    var previousScope: Scope? = nil;
    if let unwrappedPrevious = previousRoot {
      previousScope = areComponentsEquivalent(
        c1: component,
        c2: unwrappedPrevious.root.component)
        ? unwrappedPrevious.root : nil;
    }
    self.root = Scope(listener: listener,
                      component: component,
                      previousScope: previousScope,
                      stateUpdateMap: stateUpdateMap);
  }
}
