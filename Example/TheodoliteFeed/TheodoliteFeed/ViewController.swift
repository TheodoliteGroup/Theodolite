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
        (self.props,
         LabelComponent.Options(textColor: UIColor.yellow,
                                lineBreakMode: NSLineBreakMode.byWordWrapping,
                                maximumNumberOfLines: 0))
      }
    ]
  }
}

final class TestItemContent: TypedComponent {
  typealias PropType = String
  
  func render() -> [Component] {
    return [
      LabelComponent {
        (self.props,
         LabelComponent.Options(textColor: UIColor.blue,
                                lineBreakMode: NSLineBreakMode.byWordWrapping,
                                maximumNumberOfLines: 0))
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
          (self.props,
           LabelComponent.Options(textColor: UIColor.red,
                                  lineBreakMode: NSLineBreakMode.byWordWrapping,
                                  maximumNumberOfLines: 0))
      })}
    ]
  }
}

final class TestItem: TypedComponent {
  typealias PropType = String
  typealias StateType = String
  
  func handler(gesture: UITapGestureRecognizer) {
    print("yay! props: \(self.props)")
    self.updateState(state: self.state != nil ? nil : "Tapped!!!")
  }
  
  func render() -> [Component] {
    return [
      TapComponent {(
        action: Handler(self, TestItem.handler),
        component:
        FlexboxComponent {
          (options: FlexOptions(
            flexDirection: .column
            ),
           children:[
            FlexChild(TestItemHeader { self.state ?? self.props }),
            FlexChild(TestItemContent { self.state ?? self.props }),
            FlexChild(TestItemFooter { self.state ?? self.props })
            ]
          )}
        )}
    ]
  }
}

final class TestBatchComponent: TypedComponent {
  typealias PropType = Void?
  
  func render() -> [Component] {
    return [
      FlexboxComponent {
        (options: FlexOptions(
          flexDirection: .column
          ),
         children:
          (1...10)
            .map {(num: Int) -> FlexChild in
              return FlexChild(TestItem(key: num) { "Lorem ipsum dolor sit amet, ad integre tincidunt consetetur per, error atomorum vel et. Quo ad error dicam iudicabit, sumo facilisi eu his. Duo elitr vidisse theophrastus ut, possit eloquentiam vel ea. Nec no inani erant dissentias, alii reque no has, et nec virtute adversarium. Ad ancillae insolens abhorreant has, has et dictas impedit conceptam. No qui virtute eripuit, vix cu inani repudiare, hinc omittam convenire et pro. Eros quodsi detraxit cum et, has eu quas nonumy admodum, te sint soluta his." })
        })
      }
    ]
  }
}

final class TestChunkComponent: TypedComponent {
  typealias PropType = Void?
  
  func render() -> [Component] {
    return [
      FlexboxComponent {
        (options: FlexOptions(
          flexDirection: .column
          ),
         children:
          (1...10)
            .map {(num: Int) -> FlexChild in
              return FlexChild(TestBatchComponent(key: num) { nil })
        })
      }
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
            (1...10)
              .map {(num: Int) -> FlexChild in
                return FlexChild(TestChunkComponent(key: num) { nil })
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

