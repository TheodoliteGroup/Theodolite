//
//  NewsAggregationComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox
import Theodolite

final class NewsAggregationComponent: Component, TypedComponent {
  typealias PropType = (
    [URL],
    navigationCoordinator: NavigationCoordinator
  )
  typealias StateType = Int

  override func render() -> [Component] {
    return [
      PullToRefreshComponent(key: state) {
        (action: Handler(self, NewsAggregationComponent.didPullToRefresh),
         component:
          FlexboxComponent {
            (options: FlexOptions(flexDirection: .column),
             children:
              props.0
                .map {(url: URL) -> FlexChild in
                  return FlexChild(
                    NewsNetworkSourceComponent(key: url) {
                      (NewsNetworkSource(url: url), navigationCoordinator: props.navigationCoordinator)}
                  )
            })
          }
        )}
    ]
  }

  func didPullToRefresh(refreshControl: UIRefreshControl) {
    print("pulled to refresh")
    self.updateState(state: (state ?? 0) + 1)
    refreshControl.endRefreshing()
  }
}
