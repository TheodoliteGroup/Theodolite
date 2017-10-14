//
//  ScopeRoot.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public class ScopeRoot {
  public let root: Scope;
  weak var listener: StateUpdateListener?;
  
  public init(previousRoot: ScopeRoot?, listener: StateUpdateListener?, stateUpdateMap: [Int32: Any?], factory: () -> Component) {
    self.listener = listener;
    let component = factory();
    var previousScope: Scope? = nil;
    if let unwrappedPrevious = previousRoot {
      previousScope = areComponentsEquivalent(
        c1: component,
        c2: unwrappedPrevious.root.component())
        ? unwrappedPrevious.root : nil;
    }
    self.root = Scope(listener: listener,
                      component: component,
                      previousScope: previousScope,
                      stateUpdateMap: stateUpdateMap);
  }
}
