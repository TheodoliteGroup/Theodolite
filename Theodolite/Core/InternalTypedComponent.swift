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
  
  /* View handling */
  func mount(parentView: UIView, layout: Layout, insets: UIEdgeInsets) {
    self.componentWillMount();
    if let config = self.view() {
      if let view =
        ViewPoolMap
          .getViewPool(view: parentView, config: config)
          .retrieveView(parent: parentView, config: config) {
        view.frame = CGRect(x: insets.left,
                            y: insets.top,
                            width: layout.size.width,
                            height: layout.size.height);
        // If you have child components, you must call ViewPoolMap.reset(view: view) after they mount. This
        // implementation has no children, so it's not necessary.
      }
    }
    self.componentDidMount();
  }
  
  /* Implementation detail, ignore this */
  internal func view() -> ViewConfiguration? {
    let wrapper: InternalPropertyWrapper<PropType>? =
      getAssociatedObject(object: self,
                          associativeKey: &kWrapperKey);
    return wrapper?.view;
  }
  
  internal func initialUntypedState() -> Any? {
    return initialState();
  }
}

var kWrapperKey: Void?;
