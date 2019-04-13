//
//  SpinnerComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Theodolite

final class SpinnerComponent: Component, TypedComponent {
  typealias PropType = Void?

  override func view() -> ViewConfiguration? {
    return ViewConfiguration(view: UIActivityIndicatorView.self,
                             attributes: [
                              
                              Attr(UIActivityIndicatorView.Style.gray,
                                   identifier: "theodolite-activityIndicatorStyle")
                              { (view: UIActivityIndicatorView, value: UIActivityIndicatorView.Style) -> () in
                                    view.style = value
                              }
      ])
  }

  override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
    return Layout(component: self,
                  size: constraint.clamp(
                    CGSize(
                      width: constraint.max.width,
                      height: 50)),
                  children: [])
  }

  override func componentDidMount() {
    super.componentDidMount()
    let spinner = self.context.mountInfo.currentView as? UIActivityIndicatorView
    spinner?.startAnimating()
  }

  override func componentWillUnmount() {
    super.componentWillUnmount()
    (self.context.mountInfo.currentView as? UIActivityIndicatorView)?.stopAnimating()
  }
}
