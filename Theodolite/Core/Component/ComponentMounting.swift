//
//  ComponentMounting.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public extension Component {
  public func mount(parentView: UIView, layout: Layout, position: CGPoint) -> MountContext {
    return MountContext(view: parentView,
                        position: position,
                        shouldMountChildren:true)
  }
  
  public func unmount(layout: Layout) {}
  
  public func componentWillMount() {}
  public func componentDidMount() {}
  
  public func componentWillUnmount() {}
}
