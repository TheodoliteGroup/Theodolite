//
//  ComponentHostingViewSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

class ComponentHostingViewSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_singleComponentChild() {
    let view = ComponentHostingView { () -> Component in
      return LabelComponent {
        ("hello",
         LabelComponent.Options())
      }
    }
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    self.FBSnapshotVerifyView(view)
  }

  func test_stateUpdateChangesRendering() {
    final class TestComponent: TypedComponent {
      typealias PropType = () -> ()
      typealias StateType = Bool

      func render() -> [Component] {
        return [LabelComponent {
          ((self.state ?? false) ? "state updated" : "state NOT updated",
           LabelComponent.Options())
          }]
      }

      func componentDidMount() {
        if self.state == nil {
          self.updateState(state: true)
        } else {
          self.props()
        }
      }
    }

    let exp = expectation(description: "Finished remounting after state update")

    let view = ComponentHostingView { () -> Component in
      return TestComponent {
        {
          exp.fulfill()
        }
      }
    }
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    view.layoutSubviews()

    self.wait(for: [exp], timeout: 1)

    self.FBSnapshotVerifyView(view)
  }
}
