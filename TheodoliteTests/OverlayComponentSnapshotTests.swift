//
//  OverlayComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 3/29/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class OverlayComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_simpleOverlay() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return OverlayComponent(
        (component:
          LabelComponent(
            ("hello",
             LabelComponent.Options())),
         overlay:
          ViewComponent(
            ViewConfiguration(
              view: UIView.self,
              attributes: ViewOptions(backgroundColor: UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)).viewAttributes()))))
    }
  }
}
