import UIKit
import PlaygroundSupport

import Theodolite

class MyViewController : UIViewController {
  override func loadView() {
    let hostingView = ComponentHostingView { () -> Component in
      return ScrollComponent {
        (LabelComponent {
          ("Hello World",
           LabelComponent.Options())
          },
         direction: .vertical,
         attributes: [])
      }
    }
    hostingView.backgroundColor = .white
    
    self.view = hostingView
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
