//
//  ViewMountTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/12/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class ViewMountTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func test_basic_rectangle() {
    final class TestViewComponent: TypedComponent {
      typealias PropType = ViewConfiguration
      
      func view() -> ViewConfiguration? {
        return self.props()
      }
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50)
      }
    }
    
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent {
        ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
          ])
      }
    }
  }
  
  func test_component_withChild() {
    final class TestParentComponent: TypedComponent {
      typealias PropType = () -> ()
      
      func render() -> [Component] {
        return [
          TestChildComponent {self.props()}
        ]
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
          ])
      }
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50)
      }
    }
    
    final class TestChildComponent: TypedComponent {
      typealias PropType = () -> ()
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 25, height: 25)
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(UIColor.blue, applicator: {(view, color) in view.backgroundColor = color })
          ])
      }
      
      func componentDidMount() {
        self.props()()
      }
    }
    
    var didMountChild = false
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestParentComponent {{ didMountChild = true }}
    }
    
    XCTAssert(didMountChild)
  }
  
  func test_component_withNonVisibleChild_doesNotMountThatChild() {
    final class TestParentComponent: TypedComponent {
      typealias PropType = () -> ()
      
      func render() -> [Component] {
        return [
          TestChildComponent {self.props()}
        ]
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
          ])
      }
      
      func layout(constraint: CGSize, tree: ComponentTree) -> Theodolite.Layout {
        let firstChild = tree.children()[0]
        return Theodolite.Layout(component: self, size: CGSize(width: 50, height: 50), children: [
          LayoutChild(layout: firstChild.component().layout(constraint: constraint, tree: firstChild),
                      position: CGPoint(x: 150, y: 150))
          ])
      }
    }
    
    final class TestChildComponent: TypedComponent {
      typealias PropType = () -> ()
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 25, height: 25)
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(UIColor.blue, applicator: {(view, color) in view.backgroundColor = color })
          ])
      }
      
      func componentDidMount() {
        self.props()()
      }
    }
    
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function, mountVisibleOnly: true) {() -> Component in
      return TestParentComponent {{
          XCTFail("Should not have mounted child")
        }}
    }
  }
  
  func test_complex_layout() {
    final class TestLabelComponent: TypedComponent {
      typealias PropType = String
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UILabel.self,
          attributes: [
            Attr(self.props(), applicator: {(view, str) in
              let label = view as! UILabel
              label.text = str
              label.font = UIFont.systemFont(ofSize: 12)
            })
          ])
      }
      
      func size(constraint: CGSize) -> CGSize {
        let str = self.props() as NSString
        let size = str.boundingRect(with: constraint,
                                    options: NSStringDrawingOptions(),
                                    attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)],
                                    context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
      }
    }
    
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return TestLabelComponent { "Hello World" }
    }
  }
  
  func test_flexbox() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {
        (options:
          FlexOptions(flexDirection: .column),
         children:[
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options()
              )}),
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options()
              )})
          ])}
    }
  }
  
  func test_row_flexbox() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(flexDirection: .row),
        children:[
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options(
                view: ViewOptions(backgroundColor: UIColor.red),
                textColor: UIColor.blue
              )
              )}),
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options()
              )})
        ])}
    }
  }
  
  func test_row_flexbox_with_flexGrow() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(
          flexDirection: .row
        ),
        children:[
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options(
                view: ViewOptions(backgroundColor: UIColor.yellow),
                textColor: UIColor.blue)
              )},
            flexGrow: 1.0),
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options()
              )})
        ]
        )}
    }
  }
  
  func test_flexbox_inside_flexbox() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(
          flexDirection: .row
        ),
        children:[
          FlexChild(
            FlexboxComponent {(
              options:FlexOptions(
                flexDirection: .column
              ),
              children:[
                FlexChild(
                  LabelComponent {(
                    "hello world",
                    options: LabelComponent.Options(
                      view: ViewOptions(backgroundColor: UIColor.red),
                      textColor: UIColor.blue
                    )
                    )}),
                FlexChild(
                  LabelComponent {(
                    "hello world",
                    options: LabelComponent.Options()
                    )})
              ])},
            flexShrink: 1.0),
          FlexChild(
            LabelComponent {(
              "hello world",
              options: LabelComponent.Options(
                view: ViewOptions(backgroundColor: UIColor.blue),
                textColor: UIColor.red
              )
              )})
        ]
        )}
    }
  }
  
  // MARK: Simple Flexbox Tests
  
  func test_row_5050() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(
          flexDirection: .row
        ),
        children:[
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.yellow)
                  .viewAttributes())},
            flex: 0.5),
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.red)
                  .viewAttributes())},
            flex: 0.5)
        ]
        )}
    }
  }
  
  func test_row_3030() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(
          flexDirection: .row
        ),
        children:[
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.yellow)
                  .viewAttributes())},
            flex: 0.3),
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.red)
                  .viewAttributes())},
            flex: 0.3)
        ]
        )}
    }
  }
  
  func test_row_3070() {
    snapshotTestComponent(self, CGSize(width: 300, height: 100), #function) {() -> Component in
      return FlexboxComponent {(
        options:FlexOptions(
          flexDirection: .row
        ),
        children:[
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.yellow)
                  .viewAttributes())},
            flex: 0.3),
          FlexChild(
            ViewComponent {
              ViewConfiguration(
                view: UIView.self,
                attributes:
                ViewOptions(backgroundColor: UIColor.red)
                  .viewAttributes())},
            flex: 0.7)
        ]
        )}
    }
  }
}
