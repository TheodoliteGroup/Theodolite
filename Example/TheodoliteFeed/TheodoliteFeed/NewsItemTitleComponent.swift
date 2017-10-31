//
//  NewsItemHeaderComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemTitleComponent: TypedComponent {
  typealias PropType = String

  func render() -> [Component] {
    return [
      InsetComponent {(
        insets: UIEdgeInsetsMake(0, 0, 10, 0),
        component:
        LabelComponent {
          (self.props,
           LabelComponent.Options(
            font: UIFont.boldSystemFont(ofSize: 16),
            lineBreakMode: NSLineBreakMode.byWordWrapping,
            maximumNumberOfLines: 0))
      })
      }
    ]
  }
}
