import FBSnapshotTestCase
@testable import Theodolite

class ComponentViewControllerSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_componentViewController_singleComponentChild() {
    let vc = ComponentViewController { () -> Component in
      return LabelComponent(
        ("hello",
         LabelComponent.Options())
      )
    }
    vc.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    self.FBSnapshotVerifyView(vc.view)
  }
}
