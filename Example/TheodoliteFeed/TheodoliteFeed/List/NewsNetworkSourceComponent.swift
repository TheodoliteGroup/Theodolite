//
//  NewsNetworkSourceComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsNetworkSourceComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = NewsNetworkSource
  typealias StateType = (
    newsItems: [NewsItem],
    didInitiateFetch: Bool
  )

  func render() -> [Component] {
    guard let state = self.state else {
      return []
    }

    if state.newsItems.count == 0 {
      return []
    }

    var children: [FlexChild] = []
    let first = state.newsItems.first!
    children.append(FlexChild(NewsItemFeaturedComponent(key: first.url) { first }))
    children.append(contentsOf: state.newsItems[1..<state.newsItems.count]
      .map {(item: NewsItem) -> FlexChild in
        return FlexChild(NewsItemComponent(key: item.url) { item })
    })

    return [
      FlexboxComponent {
        (options: FlexOptions(flexDirection: .column),
         children: children)
      }
    ]
  }

  func componentDidMount() {
    if !(self.state?.didInitiateFetch ?? false) {
      self.updateState(state: (newsItems: [], didInitiateFetch: true))
      self.props.fetchItems({ (result) in
        switch result {
        case .error(let string):
          print("error: \(string)")
          break
        case .success(let newsItems):
          self.updateState(state: (newsItems:newsItems, didInitiateFetch: true))
          break
        }
      })
    }
  }
}
