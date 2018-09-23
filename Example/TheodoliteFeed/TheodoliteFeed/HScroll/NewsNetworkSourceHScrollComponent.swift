//
//  NewsNetworkSourceHScrollComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/4/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Theodolite
import Flexbox

final class NewsNetworkSourceHScrollComponent: Component, TypedComponent {
  typealias PropType = (
    networkSource: NewsNetworkSource,
    navigationCoordinator: NavigationCoordinator
  )
  typealias StateType = (
    newsItems: [NewsItem],
    didInitiateFetch: Bool
  )

  override func render() -> [Component] {
    self.fetchIfNeeded()

    guard let state = self.state else {
      return []
    }

    if state.newsItems.count == 0 {
      return []
    }

    let props = self.props

    return [
      ScrollComponent(
        (FlexboxComponent(
          (options: FlexOptions(flexDirection: .row),
           children: state.newsItems
            .map {(item: NewsItem) -> FlexChild in
              return FlexChild(
                SizeComponent(
                  key: item.url,
                  (size: SizeRange(CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat.nan)),
                   component:
                    NewsItemCardComponent(
                      key: item.url,
                      (item, navigationCoordinator: props.navigationCoordinator)
                  ))
              ))
          })),
         direction: .horizontal,
         attributes: [])
      )
    ]
  }

  func fetchIfNeeded() {
    if !(self.state?.didInitiateFetch ?? false) {
      self.updateState(state: (newsItems: [], didInitiateFetch: true))
      self.props.networkSource.fetchItems({ (result) in
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
