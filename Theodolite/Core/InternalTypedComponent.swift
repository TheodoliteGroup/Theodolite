//
//  InternalTypedComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

/* Used by infrastructure to allow polymorphism on prop/state types. */
public protocol InternalTypedComponent {
  func initialUntypedState() -> Any?
}

internal struct InternalPropertyWrapper<PropType> {
  let props: PropType
  let key: AnyHashable?
}

/* Default implementations of the core methods. You shouldn't override any of these methods. */
public extension TypedComponent {
  public init(_ props: PropType,
              key: AnyHashable? = nil) {
    self.init()
    setAssociatedObject(object: self,
                        value: InternalPropertyWrapper(props: props, key: key),
                        associativeKey: &kWrapperKey)
  }
  
  func props() -> PropType {
    let wrapper: InternalPropertyWrapper<PropType>? = getAssociatedObject(object: self,
                                                                         associativeKey: &kWrapperKey)
    return wrapper!.props
  }
  
  func state() -> StateType? {
    if let handle = getScopeHandle(component: self) {
      return handle.state as? StateType ?? nil
    }
    assert(false, "Accessing state before handle set on component. This state update will no-op")
    return nil
  }
  
  func initialState() -> StateType? {
    return nil
  }
  
  func updateState(state: StateType?) {
    if let handle = getScopeHandle(component: self) {
      handle.stateUpdater(handle.identifier, state)
    } else {
      assert(false, "Updating state before handle set on component. This state update will no-op")
    }
  }
  
  public func key() -> AnyHashable? {
    let wrapper: InternalPropertyWrapper<PropType>? =
      getAssociatedObject(object: self,
                          associativeKey: &kWrapperKey)
    return wrapper?.key
  }
  
  /* View handling */
  func mount(parentView: UIView, layout: Layout, position: CGPoint) {
    self.componentWillMount()
    if let config = self.view() {
      let view =
        ViewPoolMap
          .getViewPool(view: parentView, config: config)
          .retrieveView(parent: parentView, config: config)!
      view.frame = CGRect(x: position.x,
                          y: position.y,
                          width: layout.size.width,
                          height: layout.size.height)
      for childLayout in layout.children {
        childLayout.layout.component.mount(parentView: view,
                                           layout: childLayout.layout,
                                           position: childLayout.position)
      }
      // Hide any views that weren't vended from our view (not our parent's, that's their responsibility).
      ViewPoolMap.reset(view: view)
    } else {
      for childLayout in layout.children {
        childLayout.layout.component.mount(
          parentView: parentView,
          layout: childLayout.layout,
          position: CGPoint(
            x: childLayout.position.x + position.x,
            y: childLayout.position.y + position.y))
      }
    }
    self.componentDidMount()
  }
  
  func view() -> ViewConfiguration? {
    return nil
  }
  
  /* Implementation detail, ignore this */
  func initialUntypedState() -> Any? {
    return initialState()
  }
}

var kWrapperKey: Void?
