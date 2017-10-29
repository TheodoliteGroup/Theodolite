//
//  ComponentRender.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public extension Component {
  public func render() -> [Component] {
    return []
  }
  
  public func shouldComponentUpdate(previous: Component) -> Bool {
    return true
  }
}
