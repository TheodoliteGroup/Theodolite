//
//  ViewMountTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/12/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
@testable import Theodolite

class ViewMountTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func test_basic_rectangle() {
    final class TestViewComponent: TypedComponent {
      typealias PropType = ViewConfiguration;
      
      func view() -> ViewConfiguration? {
        return self.props();
      }
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50);
      }
    }
    
    snapshotTestComponent(CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(ViewConfiguration(
        view: UIView.self,
        attributes: [
          Attr(value: UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
        ]));
    }
  }
  
  func test_component_withChild() {
    final class TestParentComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component] {
        return [
          TestChildComponent()
        ];
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(value: UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
          ]);
      }
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50);
      }
    }
    
    final class TestChildComponent: TypedComponent {
      typealias PropType = Void?
      
      func size(constraint: CGSize) -> CGSize {
        return CGSize(width: 25, height: 25);
      }
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UIView.self,
          attributes: [
            Attr(value: UIColor.blue, applicator: {(view, color) in view.backgroundColor = color })
          ]);
      }
    }
    
    snapshotTestComponent(CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestParentComponent();
    }
  }
  
  func test_complex_layout() {
    final class TestLabelComponent: TypedComponent {
      typealias PropType = String
      
      func view() -> ViewConfiguration? {
        return ViewConfiguration(
          view: UILabel.self,
          attributes: [
            Attr(value: self.props(), applicator: {(view, str) in
              let label = view as! UILabel;
              label.text = str;
              label.font = UIFont.systemFont(ofSize: 12);
            })
          ]);
      }
      
      func size(constraint: CGSize) -> CGSize {
        let str = self.props() as NSString;
        let size = str.boundingRect(with: constraint,
                                    options: NSStringDrawingOptions(),
                                    attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)],
                                    context: nil).size;
        return CGSize(width: ceil(size.width), height: ceil(size.height));
      }
    }
    
    snapshotTestComponent(CGSize(width: 300, height: 100), #function) {() -> Component in
      return TestLabelComponent("Hello World");
    }
  }
  
  private func snapshotTestComponent(_ size: CGSize, _ identifier: String, factory: () -> Component) {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height));
    let scopeRoot = ScopeRoot(previousRoot: nil, listener: nil, stateUpdateMap: [:], factory: factory);
    
    let layout = scopeRoot.root.component().layout(constraint: view.bounds.size, tree: scopeRoot.root);
    
    scopeRoot.root.component().mount(parentView: view,
                                     layout: layout,
                                     position: CGPoint(x: 0, y: 0));
    
    FBSnapshotVerifyView(view, identifier: identifier);
  }
}
