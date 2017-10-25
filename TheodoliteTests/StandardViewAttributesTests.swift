//
//  StandardViewAttributesTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/24/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

class StandardViewAttributesTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  final class TestViewComponent: TypedComponent {
    typealias PropType = (
      view: ViewConfiguration,
      size: CGSize
    )
    
    public func size(constraint: CGSize) -> CGSize {
      return self.props().size
    }
    
    public func view() -> ViewConfiguration? {
      return self.props().view
    }
  }
  
  func test_backgroundColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent {
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red)
            .viewAttributes()),
         size: CGSize(width: 100, height: 100))
      }
    }
  }
  
  func test_alpha() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent {
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red,
                      alpha: 0.5)
            .viewAttributes()),
         size: CGSize(width: 100, height: 100))
      }
    }
  }
  
  func test_clipsToBounds_true() {
    final class ChildComponent: TypedComponent {
      typealias PropType = Void?
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 100, height: 50)
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red)
            .viewAttributes())
      }
    }
    
    final class ParentComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component?] {
        return [ChildComponent()]
      }
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 50, height: 60)
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.blue,
                      clipsToBounds:true)
            .viewAttributes())
      }
    }
    
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ParentComponent()
    }
  }
  
  func test_contentMode_isApplied() {
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(contentMode: UIViewContentMode.scaleAspectFit).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)
    
    XCTAssertEqual(view.contentMode, UIViewContentMode.scaleAspectFit)
  }
  
  func test_tintColor_isApplied() {
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(tintColor: UIColor.red).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)
    
    XCTAssertEqual(view.tintColor, UIColor.red)
  }
  
  func test_multipleTouchEnabled_isApplied() {
    // Too hard to do this in a snapshot, so just build the attr, and apply it
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(isMultipleTouchEnabled: true).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)
    
    XCTAssertEqual(view.isMultipleTouchEnabled, true)
  }
  
  func test_isExclusiveTouchEnabled_isApplied() {
    // Too hard to do this in a snapshot, so just build the attr, and apply it
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(isExclusiveTouchEnabled: true).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)
    
    XCTAssertEqual(view.isExclusiveTouch, true)
  }
}

