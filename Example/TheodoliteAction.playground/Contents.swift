import UIKit
import PlaygroundSupport

import Theodolite

final class ViewComponent: TypedComponent {
  typealias PropType = ViewConfiguration
  
  public func view() -> ViewConfiguration? {
    return self.props()
  }
  
  public func size(constraint: CGSize) -> CGSize {
    return constraint
  }
}

final class TestComponent: TypedComponent {
  typealias PropType = Void?
  
  func render() -> [Component] {
    return [
      ViewComponent {
        ViewConfiguration(
          view: UIView.self,
          attributes:
          [
            TapAttribute(Handler(self, TestComponent.actionMethod))
          ])
      }
    ]
  }
  
  func actionMethod(gesture: UITapGestureRecognizer) {
    print("tapped!")
  }
}

class MyViewController : UIViewController {
  override func loadView() {
    let hostingView = ComponentHostingView { () -> Component in
      return TestComponent {nil}
    }
    hostingView.backgroundColor = .white
    
    self.view = hostingView
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


