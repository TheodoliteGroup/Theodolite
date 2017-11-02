//
//  TapComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public final class TapComponent: TypedComponent {
  public let context = ComponentContext()
  public typealias PropType = (
    action: Action<UITapGestureRecognizer>,
    component: Component
  )
  
  public init() {}
  
  public func render() -> [Component] {
    return [self.props.component]
  }
  
  public func view() -> ViewConfiguration? {
    return ViewConfiguration(
      view: UIView.self,
      attributes: [
        TapAttribute(self.props.action)
      ])
  }
}
