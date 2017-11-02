//
//  ViewComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/31/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class ViewComponent: TypedComponent {
  public let context = ComponentContext()
  public typealias PropType = ViewConfiguration

  public init() {}

  public func view() -> ViewConfiguration? {
    return self.props
  }

  public func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    return Layout(component: self,
                  size: constraint.max,
                  children: [])
  }
}
