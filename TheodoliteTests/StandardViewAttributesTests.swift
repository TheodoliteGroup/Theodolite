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
  
  final class TestViewComponent: Component, TypedComponent {
    
    typealias PropType = (
      view: ViewConfiguration,
      size: CGSize
    )
    
    public override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
      return Layout(component: self,
                    size: self.props.size,
                    children: [])
    }
    
    public override func view() -> ViewConfiguration? {
      return self.props.view
    }
  }
  
  func test_backgroundColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red)
            .viewAttributes()),
         size: CGSize(width: 100, height: 100))
      )
    }
  }
  
  func test_alpha() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red,
                      alpha: 0.5)
            .viewAttributes()),
         size: CGSize(width: 100, height: 100))
      )
    }
  }
  
  func test_clipsToBounds_true() {
    final class ChildComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      
      override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
        return Layout(component: self,
                      size: CGSize(width: 100, height: 50),
                      children: [])
      }
      
      override func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.red)
            .viewAttributes())
      }
    }
    
    final class ParentComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      
      override func render() -> [Component] {
        return [ChildComponent(nil)]
      }
      
      override func layout(constraint: SizeRange, tree: ComponentTree) -> Layout {
        return Layout(component: self,
                      size: CGSize(width: 50, height: 60),
                      children: [
                        LayoutChild(
                          layout: tree
                            .children()[0]
                            .component()
                            .layout(constraint: constraint,
                                    tree: tree.children()[0]),
                          position: CGPoint(x: 0, y: 0))
          ])
      }
      
      override func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(backgroundColor: UIColor.blue,
                      clipsToBounds:true)
            .viewAttributes())
      }
    }
    
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return ParentComponent(nil)
    }
  }
  
  func test_contentMode_isApplied() {
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(contentMode: UIView.ContentMode.scaleAspectFit).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)
    
    XCTAssertEqual(view.contentMode, UIView.ContentMode.scaleAspectFit)
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

  func test_accessibilityEnabled_isApplied() {
    // Too hard to do this in a snapshot, so just build the attr, and apply it
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(isAccessibilityElement: true).viewAttributes())
    let view = UIView()
    config.applyToView(v: view)

    XCTAssertEqual(view.isAccessibilityElement, true)
  }

  func test_accessibilityLabel_isApplied() {
    // Too hard to do this in a snapshot, so just build the attr, and apply it
    let config = ViewConfiguration(
      view: UIView.self,
      attributes:
      ViewOptions(accessibilityLabel: "Hello").viewAttributes())
    let view = UIView()
    config.applyToView(v: view)

    XCTAssertEqual(view.accessibilityLabel, "Hello")
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

  func test_cornerRadius() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(
            backgroundColor: UIColor.red,
            layerOptions:
            LayerOptions(cornerRadius: 15)
          )
          .viewAttributes()),
         size: CGSize(width: 100, height: 100))
      )
    }
  }

  func test_borderWidth_andColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(
            backgroundColor: UIColor.red,
            layerOptions:
            LayerOptions(borderWidth: 4,
                         borderColor: UIColor.blue)
            )
            .viewAttributes()),
         size: CGSize(width: 50, height: 50))
      )
    }
  }

  func test_borderWidth_shadow() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(
        (view: ViewConfiguration(
          view: UIView.self,
          attributes:
          ViewOptions(
            backgroundColor: UIColor.red,
            layerOptions:
            LayerOptions(shadowColor: UIColor.blue,
                         shadowOpacity: 0.8,
                         shadowOffset: CGSize(width: 2, height: 2),
                         shadowRadius: 4)
            )
            .viewAttributes()),
         size: CGSize(width: 50, height: 50))
      )
    }
  }
}

