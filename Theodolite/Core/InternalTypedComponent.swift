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

public extension InternalTypedComponent {
}

internal protocol InternalPropertyWrapperProtocol: class {
  var currentView: UIView? {get set}
  var mountContext: MountContext? {get set}
}

internal class InternalPropertyWrapper<PropType>: InternalPropertyWrapperProtocol {
  let props: PropType?
  let key: AnyHashable?
  
  var currentView: UIView? = nil
  var mountContext: MountContext? = nil
  
  init(props: PropType?,
       key: AnyHashable?) {
    self.props = props
    self.key = key
  }
}

/* Default implementations of the core methods. You shouldn't override any of these methods. */
public extension TypedComponent {
  public init(key: AnyHashable? = nil,
              _ props: () -> PropType) {
    self.init()
    setAssociatedObject(object: self,
                        value: InternalPropertyWrapper(props: props(), key: key),
                        associativeKey: &kWrapperKey)
  }
  
  public func key() -> AnyHashable? {
    return wrapper().key
  }
  
  /* Implementation detail, ignore this. TODO: Remove? */
  func initialUntypedState() -> Any? {
    return initialState()
  }
  
  internal func wrapper() -> InternalPropertyWrapper<PropType> {
    guard let wrapper: InternalPropertyWrapper<PropType> =
      getAssociatedObject(object: self, associativeKey: &kWrapperKey)
      else {
        assert(Thread.isMainThread,
               "Use the init(props) constructor in order to make the wrapper available off the main thread.")
        let newWrapper: InternalPropertyWrapper<PropType> = InternalPropertyWrapper(props: nil, key: nil)
        setAssociatedObject(object: self,
                            value: newWrapper,
                            associativeKey: &kWrapperKey)
        return newWrapper
    }
    return wrapper
  }
}

internal func GetWrapper(_ component: Component?) -> InternalPropertyWrapperProtocol? {
  guard let c = component else {
    return nil
  }
  return getAssociatedObject(object: c, associativeKey: &kWrapperKey)
}

var kWrapperKey: Void?
