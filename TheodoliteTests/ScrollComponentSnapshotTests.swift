//
//  ScrollComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/27/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class ScrollComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = true
  }
  
  func test_basicScrollComponent() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ScrollComponent {
        (LabelComponent {
          ("Hello World",
           LabelComponent.Options())
          },
         direction: .vertical,
         attributes: [])
      }
    }
  }
}
