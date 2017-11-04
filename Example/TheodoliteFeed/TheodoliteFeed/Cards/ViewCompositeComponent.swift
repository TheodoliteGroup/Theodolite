//
//  ViewCompositeComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/4/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class ViewCompositeComponent: Component, TypedComponent {
  typealias PropType = (ViewConfiguration, Component)

  override func render() -> [Component] {
    return [self.props.1]
  }

  override func view() -> ViewConfiguration? {
    return self.props.0
  }
}
