//
//  NewsItemDescriptionComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemDescriptionComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = String

  func render() -> [Component] {
    return [
      LabelComponent {
        (self.props,
         LabelComponent.Options(textColor: UIColor(white: 0.3, alpha: 1),
          lineBreakMode: NSLineBreakMode.byWordWrapping,
                                maximumNumberOfLines: 0))
      }
    ]
  }
}
