//
//  BackgroundComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 3/29/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class BackgroundComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_simpleBackground() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return BackgroundComponent(
        (component:
          LabelComponent(
            ("hello",
             LabelComponent.Options())),
         background:
          ViewComponent(
            ViewConfiguration(
              view: UIView.self,
              attributes: ViewOptions(backgroundColor: UIColor.blue).viewAttributes()))))
    }
  }
}
