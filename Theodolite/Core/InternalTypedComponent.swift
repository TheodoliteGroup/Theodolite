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

internal protocol ComponentContextProtocol: class {
  var mountInfo: MountInfo {get set}
}

internal struct MountInfo {
  var currentView: UIView? = nil
  var mountContext: MountContext? = nil
  var mountedLayout: Layout? = nil
}

internal class ComponentContext<PropType>: ComponentContextProtocol {
  let props: PropType?
  let key: AnyHashable?
  
  var mountInfo: MountInfo
  
  init(props: PropType?,
       key: AnyHashable?) {
    self.props = props
    self.key = key
    self.mountInfo = MountInfo()
  }
}

/* Default implementations of the core methods. You shouldn't override any of these methods. */
public extension TypedComponent {
  public init(key: AnyHashable? = nil,
              _ props: () -> PropType) {
    self.init()
    setAssociatedObject(object: self,
                        value: ComponentContext(props: props(), key: key),
                        associativeKey: &kWrapperKey)
  }
  
  public func key() -> AnyHashable? {
    return context().key
  }
  
  /* Implementation detail, ignore this. TODO: Remove? */
  func initialUntypedState() -> Any? {
    return initialState()
  }
  
  internal func context() -> ComponentContext<PropType> {
    guard let context: ComponentContext<PropType> =
      getAssociatedObject(object: self, associativeKey: &kWrapperKey)
      else {
        assert(Thread.isMainThread,
               "Use the init(props) constructor in order to make component context available off the main thread.")
        let newContext: ComponentContext<PropType> = ComponentContext(props: nil, key: nil)
        setAssociatedObject(object: self,
                            value: newContext,
                            associativeKey: &kWrapperKey)
        return newContext
    }
    return context
  }
}

internal func GetContext(_ component: Component?) -> ComponentContextProtocol? {
  guard let c = component else {
    return nil
  }
  return getAssociatedObject(object: c, associativeKey: &kWrapperKey)
}

var kWrapperKey: Void?
