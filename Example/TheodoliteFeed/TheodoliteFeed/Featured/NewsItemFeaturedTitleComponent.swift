//
//  NewsItemFeaturedTitleComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemFeaturedTitleComponent: TypedComponent {
  typealias PropType = String

  func render() -> [Component] {
    return [
      InsetComponent {(
        insets: UIEdgeInsetsMake(0, 0, 10, 0),
        component:
        LabelComponent {
          (self.props,
           LabelComponent.Options(
            font: UIFont(name: "Georgia", size: 24)!,
            lineBreakMode: NSLineBreakMode.byWordWrapping,
            maximumNumberOfLines: 0))
      })
      }
    ]
  }
}
