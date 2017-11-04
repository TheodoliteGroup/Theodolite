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
  typealias StateType = (
    currentIndex: Int,
    sentinel: Int
  )

  func initialState() -> (currentIndex: Int, sentinel: Int)? {
    return (currentIndex: 0, sentinel: 0)
  }

  override func render() -> [Component] {
    return [
      PullToRefreshComponent(key: state!.sentinel) {
        (action: Handler(self, NewsAggregationComponent.didPullToRefresh),
         component:
          FlexboxComponent {
            (options: FlexOptions(flexDirection: .column),
             children:
              props.0[0 ... state!.currentIndex]
                .map {(url: URL) -> FlexChild in
                  return FlexChild(
                    NewsNetworkSourceComponent(key: url) {
                      (NewsNetworkSource(url: url),
                       loadedAction: Handler(self, NewsAggregationComponent.childLoaded),
                       navigationCoordinator: props.navigationCoordinator)}
                  )
            })
          }
        )}
    ]
  }

  func childLoaded(loaded: Bool) {
    if (state!.currentIndex + 1 < props.0.count) {
      self.updateState(state: (currentIndex: state!.currentIndex + 1,
                               sentinel: state!.sentinel))
    }
  }

  func didPullToRefresh(refreshControl: UIRefreshControl) {
    self.updateState(state: (currentIndex: 0,
                             sentinel:state!.sentinel + 1))
    refreshControl.endRefreshing()
  }
}
