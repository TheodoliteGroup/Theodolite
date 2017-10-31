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
  typealias PropType = String

  func render() -> [Component] {
    return [
      LabelComponent {
        (self.props,
         LabelComponent.Options(lineBreakMode: NSLineBreakMode.byWordWrapping,
                                maximumNumberOfLines: 0))
      }
    ]
  }
}
