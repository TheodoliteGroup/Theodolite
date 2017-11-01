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
  typealias StateType = UIImage

  func render() -> [Component] {
    return [
      NetworkDataComponent {
        (props,
         { (state: NetworkDataComponent.State) -> Component? in
          var component: Component? = nil
          switch state {
          case .pending:
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
            break
          case .data(let data):
            guard let image = self.state ?? UIImage(data: data) else {
              break
            }
            if self.state == nil {
              self.updateState(state: image)
            }
            component = ImageComponent {
              (image,
               size: CGSize(width: 60, height: 60),
               options: ViewOptions(
                clipsToBounds: true,
                contentMode: .scaleAspectFill))
            }
            break
          case .error:
            break
          }

          if let component = component {
            return InsetComponent {
              (insets: UIEdgeInsetsMake(0, 0, 0, 10),
               component:component)
            }
          }
          return nil
        })
      }
    ]
  }
}
