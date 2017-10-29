//
//  ViewController.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

import Theodolite

final class TestComponent: TypedComponent {
  typealias PropType = Void?
  
  func render() -> [Component] {
    return [
      ScrollComponent {
        (FlexboxComponent {
          (options: FlexOptions(
            flexDirection: .column
            ),
           children:
            Array(repeating: "Hello World", count: 1000)
              .map {(str: String) -> FlexChild in
                return FlexChild(
                  LabelComponent {
                    (str,
                     LabelComponent.Options())
                })
          })
          },
         direction: .vertical,
         attributes: [])
      }
    ]
  }
}

class ViewController: UIViewController {
  
  override func loadView() {
    let hostingView = ComponentHostingView { () -> Component in
      return TestComponent {nil}
    }
    hostingView.backgroundColor = .white
    
    self.view = hostingView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

