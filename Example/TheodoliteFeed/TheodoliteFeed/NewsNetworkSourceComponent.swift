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
  typealias PropType = NewsNetworkSource
  typealias StateType = (
    newsItems: [NewsItem],
    didInitiateFetch: Bool
  )

  func render() -> [Component] {
    guard let state = self.state else {
      return [
        SpinnerComponent { nil }
      ]
    }

    if state.newsItems.count == 0 {
      return [
        SpinnerComponent { nil }
      ]
    }

    return [
      FlexboxComponent {
        (options: FlexOptions(flexDirection: .column),
         children:
          state.newsItems
            .map {(item: NewsItem) -> FlexChild in
              return FlexChild(NewsItemComponent(key: item.url) { item })
        })
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
