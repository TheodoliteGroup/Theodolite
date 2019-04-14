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
      return LabelComponent(
        ("hello",
         LabelComponent.Options())
      )
    }
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    self.FBSnapshotVerifyView(view)
  }

  func test_stateUpdateChangesRendering() {
    final class TestComponent: Component, TypedComponent {
      
      typealias PropType = () -> ()
      typealias StateType = Bool

      override func render() -> [Component] {
        return [LabelComponent(
          ((self.state ?? false) ? "state updated" : "state NOT updated",
           LabelComponent.Options())
          )]
      }

      override func componentDidMount() {
        if self.state == nil {
          self.updateState(state: true)
        } else {
          self.props()
        }
      }
    }

    var calledUpdate = false

    let view = ComponentHostingView { () -> Component in
      return TestComponent(
        {
          calledUpdate = true
        }
      )
    }
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    view.layoutSubviews()

    waitUntil(timeout: 2) { () -> Bool in
      return calledUpdate
    }

    view.layoutSubviews()

    self.FBSnapshotVerifyView(view)
  }
  
  func test_stateUpdateChangesRendering_forDeepViewTree() {
    final class TestComponent: Component, TypedComponent {
      
      typealias PropType = () -> ()
      typealias StateType = Bool
      
      override func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: ViewOptions(backgroundColor: (self.state ?? false)
            ? UIColor.red.withAlphaComponent(0.2)
            : UIColor.blue.withAlphaComponent(0.2)).viewAttributes())
      }
      
      override func render() -> [Component] {
        return [
          BackgroundComponent(
            (component:
              LabelComponent(
                (((self.state ?? false) ? "state updated" : "state NOT updated"),
                 LabelComponent.Options())),
             background:
              ViewComponent(
                ViewConfiguration(
                  view: UIView.self,
                  attributes: ViewOptions(backgroundColor:
                    ((self.state ?? false)
                      ? UIColor.blue.withAlphaComponent(0.5)
                      : UIColor.red.withAlphaComponent(0.5))).viewAttributes()))))
        ]
      }
      
      override func componentDidMount() {
        if self.state == nil {
          self.updateState(state: true)
        } else {
          self.props()
        }
      }
    }
    
    var calledUpdate = false
    
    let view = ComponentHostingView { () -> Component in
      return TestComponent(
        {
          calledUpdate = true
        }
      )
    }
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    view.layoutSubviews()
    
    waitUntil(timeout: 2) { () -> Bool in
      return calledUpdate
    }
    
    view.layoutSubviews()
    
    self.FBSnapshotVerifyView(view)
  }
}

func waitUntil(timeout: TimeInterval, _ block: () -> Bool) {
  let target = CFAbsoluteTimeGetCurrent() + timeout
  while(!block()) {
    RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.02))
    if CFAbsoluteTimeGetCurrent() > target {
      break
    }
  }
}
