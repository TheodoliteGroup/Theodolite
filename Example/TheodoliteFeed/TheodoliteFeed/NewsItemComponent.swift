//
//  NewsItemComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsItemComponent: TypedComponent {
  typealias PropType = NewsItem

  func render() -> [Component] {
    var children: [FlexChild] = []
    children.append(FlexChild(NewsItemHeaderComponent { self.props.title }))
    if let description = self.props.description {
      children.append(FlexChild(NewsItemDescriptionComponent { description }))
    }
    return [
      FlexboxComponent {
        (options: FlexOptions(flexDirection: .column),
         children: children)
      }
    ]
  }
}
