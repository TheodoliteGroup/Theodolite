//
//  TapComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
import UIKit
@testable import Theodolite

class TapComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func test_tapAttribute_notEqual() {
    class TestClass {
      func actionMethod(gesture: UITapGestureRecognizer) {}
    }
    // Tap targets always have to remove, they don't implement equality.
    let target = TestClass()
    let attr1 = TapAttribute(Handler(target, TestClass.actionMethod))
    let attr2 = TapAttribute(Handler(target, TestClass.actionMethod))
    XCTAssertNotEqual(attr1, attr2)
  }

  func test_tapAttribute_applied_addsGesture() {
    class TestClass {
      func actionMethod(gesture: UITapGestureRecognizer) {}
    }
    let view = UIView()
    let target = TestClass()
    let attr = TapAttribute(Handler(target, TestClass.actionMethod))
    attr.apply(view: view)
    XCTAssert(view.gestureRecognizers![0].isKind(of: UITapGestureRecognizer.self))
  }

  func test_tapAttribute_unapplied_removesGesture() {
    class TestClass {
      func actionMethod(gesture: UITapGestureRecognizer) {}
    }
    let view = UIView()
    let target = TestClass()
    let attr = TapAttribute(Handler(target, TestClass.actionMethod))
    attr.apply(view: view)
    attr.unapply(view: view)
    XCTAssert(view.gestureRecognizers?.count ?? 0 == 0)
  }

  func test_tapAttribute_whenActivated_doesCallActionMethod() {
    class TestClass {
      let fired: (UITapGestureRecognizer) -> ()

      init(fired: @escaping (UITapGestureRecognizer) -> ()) {
        self.fired = fired
      }

      func actionMethod(gesture: UITapGestureRecognizer) {
        self.fired(gesture)
      }
    }
    let view = UIView()
    var fired = false
    let target = TestClass { (gesture) in
      fired = true
    }
    let attr = TapAttribute(Handler(target, TestClass.actionMethod))
    attr.apply(view: view)
    view.gestureRecognizers![0].execute()
    XCTAssertTrue(fired)
  }

  func test_tapAttribute_whenActivated_callsActionMethod_withCorrectGesture() {
    class TestClass {
      let fired: (UITapGestureRecognizer) -> ()

      init(fired: @escaping (UITapGestureRecognizer) -> ()) {
        self.fired = fired
      }

      func actionMethod(gesture: UITapGestureRecognizer) {
        self.fired(gesture)
      }
    }
    let view = UIView()
    var firedGesture: UITapGestureRecognizer? = nil
    let target = TestClass { (gesture) in
      firedGesture = gesture
    }
    let attr = TapAttribute(Handler(target, TestClass.actionMethod))
    attr.apply(view: view)
    let gesture = view.gestureRecognizers![0] as! UITapGestureRecognizer
    view.gestureRecognizers![0].execute()
    XCTAssert(firedGesture === gesture)
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
