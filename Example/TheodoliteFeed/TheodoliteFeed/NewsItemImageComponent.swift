//
//  NewsItemImageComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/31/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NewsItemImageComponent: TypedComponent {
  typealias PropType = URL
  typealias StateType = (
    initiatedFetch: Bool,
    failed: Bool,
    image: UIImage?
  )

  func render() -> [Component] {
    if state == nil {
      self.updateState(state: (initiatedFetch: true, failed: false, image: nil))
      DispatchQueue.global().async {
        do {
          // This is inefficient, but this is a demo app and I don't want to take any deps, so we're just gonna block
          let data = try Data(contentsOf: self.props)
          let image = UIImage(data: data)
          self.updateState(state: (initiatedFetch: true, failed: false, image: image))
        } catch {
          print("data retrieval or parsing threw")
          self.updateState(state: (initiatedFetch: true, failed: true, image: nil))
        }
      }
    }

    if state?.failed ?? false {
      return []
    }

    let component: Component
    if let image = self.state?.image {
      component = ImageComponent {
        (image,
         size: CGSize(width: 60, height: 60),
         options: ViewOptions(
          clipsToBounds: true,
          contentMode: .scaleAspectFill))
      }
    } else {
      component = SizeComponent {
        (size: CGSize(width: 60, height: 60),
         component: ViewComponent {
          ViewConfiguration(
            view: UIView.self,
            attributes:
            ViewOptions(backgroundColor: UIColor(white: 0.95, alpha: 1))
              .viewAttributes())
        })
      }
    }

    return [
      InsetComponent {
        (insets: UIEdgeInsetsMake(0, 0, 0, 10),
         component:component)
      }
    ]
  }
}
