import UIKit
import PlaygroundSupport

import Theodolite

class MyViewController : UIViewController {
  override func loadView() {
    
    
    let hostingView = ComponentHostingView { () -> Component in
      return ScrollComponent {
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
    }
    hostingView.backgroundColor = .white
    
    self.view = hostingView
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

