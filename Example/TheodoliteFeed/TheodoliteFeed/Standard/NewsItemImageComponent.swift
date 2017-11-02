//
//  NewsItemImageComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/31/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NewsItemImageComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = URL
  typealias StateType = UIImage

  func render() -> [Component] {
    return [
      NetworkImageComponent {
        (props,
         size: CGSize(width: 60, height: 60),
         insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10),
         backgroundColor: UIColor(white: 0.95, alpha: 1),
         contentMode: .scaleAspectFill)
      }
    ]
  }
}
