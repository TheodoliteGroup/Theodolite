//
//  SpinnerComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Theodolite

final class SpinnerComponent: TypedComponent {
  typealias PropType = Void?
  typealias ViewType = UIActivityIndicatorView

  func view() -> ViewConfiguration? {
    return ViewConfiguration(view: UIActivityIndicatorView.self,
                             attributes: [
                              
                              Attr(UIActivityIndicatorViewStyle.gray,
                                   identifier: "theodolite-activityIndicatorStyle")
                              { (view: UIActivityIndicatorView, value: UIActivityIndicatorViewStyle) -> () in
                                    view.activityIndicatorViewStyle = value
                              }
      ])
  }

  func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    return Layout(component: self,
                  size: constraint.clamp(
                    CGSize(
                      width: constraint.max.width,
                      height: 50)),
                  children: [])
  }

  func componentDidMount() {
    let spinner = self.context().mountInfo.currentView
    spinner?.startAnimating()
  }

  func componentWillUnmount() {
    self.context().mountInfo.currentView?.stopAnimating()
  }
}
