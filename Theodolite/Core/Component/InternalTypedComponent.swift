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
  
  /* Implementation detail, ignore this. TODO: Remove? */
  func initialUntypedState() -> Any? {
    return initialState()
  }
  
  internal func context() -> ComponentContext<PropType, ViewType> {
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

var kWrapperKey: Void?

internal func GetContext(_ component: Component) -> ComponentContextProtocol? {
  return getAssociatedObject(object: component, associativeKey: &kWrapperKey)
}

internal protocol MountInfoProtocol {
  var mountContext: MountContext? {get set}
  var mountedLayout: Layout? {get set}
}

internal struct MountInfo<ViewType: UIView>: MountInfoProtocol {
  var currentView: ViewType? = nil
  var mountContext: MountContext? = nil
  var mountedLayout: Layout? = nil
}

/** To allow use of the component context's mount info outside of Components where the typealiases are defined. */
internal protocol ComponentContextProtocol {
  var untypedMountInfo: MountInfoProtocol {get set}
}

internal class ComponentContext<PropType, ViewType: UIView>: ComponentContextProtocol {
  var untypedMountInfo: MountInfoProtocol {
    get {
      return self.mountInfo
    }
    set(newValue) {
      self.mountInfo = newValue as! MountInfo<ViewType>
    }
  }
  
  let props: PropType?
  let key: AnyHashable?
  
  var mountInfo: MountInfo<ViewType>
  
  
  
  init(props: PropType?,
       key: AnyHashable?) {
    self.props = props
    self.key = key
    self.mountInfo = MountInfo()
  }
}
