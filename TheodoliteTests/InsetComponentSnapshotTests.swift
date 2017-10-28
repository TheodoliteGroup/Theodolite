//
//  InsetComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class InsetComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func test_simpleInsets() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return InsetComponent {
        (insets: UIEdgeInsets(top: 20, left: 15, bottom: 30, right: 20),
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
  
  func test_insetsThatAreLargerThanAvailableSize() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return InsetComponent {
        (insets: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60),
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
