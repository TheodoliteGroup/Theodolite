//
//  Component.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public protocol Component: class {
  init()
  
  /** Core methods */
  func render() -> [Component]
  func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext
  func unmount(layout: Layout)
  func layout(constraint: SizeRange, tree: ComponentTree) -> Layout
  
  /**
   Implement this if you want to control memoization of your component. By default TypedComponents will memoize if
   their PropType is Equatable. This method will only be called if there are no state updates for this component or
   any of its descendents.
  */
  func shouldComponentUpdate(previous: Component) -> Bool
  
  /** Lifecycle methods */
  
  /** Mount: attaching to a view */
  func componentWillMount()
  func componentDidMount()

  /** Unmount: detaching from a view */
  func componentWillUnmount()
  
  /** Used to identify the component so it can be associated with its prior state. */
  func key() -> AnyHashable?
}
