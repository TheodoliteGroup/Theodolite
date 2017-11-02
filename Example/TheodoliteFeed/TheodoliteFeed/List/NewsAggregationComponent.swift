//
//  NewsAggregationComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsAggregationComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = [URL]

  func render() -> [Component] {
    return [
      FlexboxComponent {
        (options: FlexOptions(flexDirection: .column),
         children:
          props
            .map {(url: URL) -> FlexChild in
              return FlexChild(
                NewsNetworkSourceComponent(key: url) {
                  NewsNetworkSource(url: url)}
              )
        })
      }
    ]
  }
}
