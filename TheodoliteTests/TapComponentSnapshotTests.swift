//
//  TapComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

class TapComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_blankRendering() {
    // Tap component shouldn't impact the rendering
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TapComponent {
        (action: Action(),
         component: ViewComponent {
          ViewConfiguration(
            view: UIView.self,
            attributes: [
              Attr(UIColor.blue, applicator: {(view, color) in view.backgroundColor = color })
            ])
        })
      }
    }
  }
}
