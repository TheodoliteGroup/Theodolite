//
//  NetworkImageComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

final class NetworkImageComponent: TypedComponent {
  let context = ComponentContext()
  typealias PropType = (
    URL,
    size: CGSize,
    insets: UIEdgeInsets,
    backgroundColor: UIColor,
    contentMode: UIViewContentMode
  )
  typealias StateType = UIImage

  func render() -> [Component] {
    let props = self.props
    return [
      NetworkDataComponent {
        (props.0,
         { (state: NetworkDataComponent.State) -> Component? in
          var component: Component? = nil
          switch state {
          case .pending:
            component = SizeComponent {
              (size: props.size,
               component: ViewComponent {
                ViewConfiguration(
                  view: UIView.self,
                  attributes:
                  ViewOptions(backgroundColor: props.backgroundColor)
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
               size: props.size,
               options: ViewOptions(
                clipsToBounds: true,
                contentMode: props.contentMode))
            }
            break
          case .error:
            break
          }

          if let component = component {
            return InsetComponent {
              (insets: props.insets,
               component:component)
            }
          }
          return nil
        })
      }
    ]
  }
}
