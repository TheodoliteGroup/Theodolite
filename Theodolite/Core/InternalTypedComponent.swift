//
//  InternalTypedComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

/* Used by infrastructure to allow polymorphism on prop/state types. */
protocol InternalTypedComponent {
  func initialUntypedState() -> Any?;
}

internal struct InternalPropertyWrapper<PropType> {
  let props: PropType;
  let view: ViewConfiguration?;
  let key: AnyHashable?;
}

/* Default implementations of the core methods. You shouldn't override any of these methods. */
extension TypedComponent {
  public init(_ props: PropType,
              view: ViewConfiguration? = nil,
              key: AnyHashable? = nil) {
    self.init();
    setAssociatedObject(object: self,
                        value: InternalPropertyWrapper(props: props,
                                                       view: view,
                                                       key: key),
                        associativeKey: &kWrapperKey);
  }
  
  func props() -> PropType {
    let wrapper: InternalPropertyWrapper<PropType>? = getAssociatedObject(object: self,
                                                                         associativeKey: &kWrapperKey);
    return wrapper!.props;
  }
  
  func state() -> StateType? {
    if let handle = getScopeHandle(component: self) {
      return handle.state as? StateType ?? nil;
    }
    assert(false, "Accessing state before handle set on component. This state update will no-op");
    return nil;
  }
  
  func initialState() -> StateType? {
    return nil;
  }
  
  func updateState(state: StateType?) {
    if let handle = getScopeHandle(component: self) {
      handle.stateUpdater(handle.identifier, state);
    } else {
      assert(false, "Updating state before handle set on component. This state update will no-op");
    }
  }
  
  internal func key() -> AnyHashable? {
    let wrapper: InternalPropertyWrapper<PropType>? =
      getAssociatedObject(object: self,
                          associativeKey: &kWrapperKey);
    return wrapper?.key;
  }
  
  /* Implementation detail, ignore this */
  internal func initialUntypedState() -> Any? {
    return initialState();
  }
}

var kWrapperKey: Void?;
