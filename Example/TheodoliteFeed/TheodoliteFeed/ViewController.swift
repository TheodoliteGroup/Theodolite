//
//  ViewController.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

import Theodolite

struct Item {
  let string: String
}

final class TestItemHeader: TypedComponent {
  typealias PropType = String
  
  func render() -> [Component] {
    return [
      LabelComponent {
        (self.props(),
         LabelComponent.Options(textColor: UIColor.yellow))
      }
    ]
  }
}

final class TestItemContent: TypedComponent {
  typealias PropType = String
  
  func render() -> [Component] {
    return [
      LabelComponent {
        (self.props(),
         LabelComponent.Options(textColor: UIColor.blue))
      }
    ]
  }
}

final class TestItemFooter: TypedComponent {
  typealias PropType = String
  
  func render() -> [Component] {
    return [
      InsetComponent {(
        insets: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0),
        component:
        LabelComponent {
          (self.props(),
           LabelComponent.Options(textColor: UIColor.red))
      })}
    ]
  }
}

final class TestItem: TypedComponent {
  typealias PropType = String
  
  func render() -> [Component] {
    return [
      FlexboxComponent {
        (options: FlexOptions(
          flexDirection: .column
          ),
         children:[
            FlexChild(TestItemHeader { self.props() }),
            FlexChild(TestItemContent { self.props() }),
            FlexChild(TestItemFooter { self.props() })
          ]
          )}
    ]
  }
}

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
                return FlexChild(TestItem { str })
          })},
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

