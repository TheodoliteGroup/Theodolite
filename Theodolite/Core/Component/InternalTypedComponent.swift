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

/* Default implementations of the core methods. You shouldn't override any of these methods. */
public extension TypedComponent {
  public init(key: AnyHashable? = nil,
              _ props: () -> PropType) {
    self.init()
    
    setAssociatedObject(object: self,
                        value: ComponentContext<PropType, ViewType>(props: props(), key: key),
                        associativeKey: &kWrapperKey)
  }
  
  public func key() -> AnyHashable? {
    return context().key
  }
  
  public func shouldComponentUpdate(previous: Component) -> Bool {
    // Note that we don't use self.props here, since that force-unwraps props
    if let props = self.context().props as? AnyHashable {
      if let previousProps = (previous as? Self)?.context().props as? AnyHashable {
        return props != previousProps
      }
    }
    return true
  }
  
  /* Implementation detail, ignore this. TODO: Remove? */
  func initialUntypedState() -> Any? {
    return initialState()
  }
  
  func context() -> ComponentContext<PropType, ViewType> {
    guard let context: ComponentContext<PropType, ViewType> =
      getAssociatedObject(object: self, associativeKey: &kWrapperKey)
      else {
        assert(Thread.isMainThread,
               "Use the init(props) constructor in order to make component context available off the main thread.")
        let newContext: ComponentContext<PropType, ViewType> = ComponentContext(props: nil, key: nil)
        setAssociatedObject(object: self,
                            value: newContext,
                            associativeKey: &kWrapperKey)
        return newContext
    }
    return context
  }
}
