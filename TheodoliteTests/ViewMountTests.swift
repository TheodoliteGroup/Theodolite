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
      typealias PropType = Void?
      
      func size() -> CGSize {
        return CGSize(width: 50, height: 50);
      }
    }
    
    snapshotTestComponent(CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(nil, view: ViewConfiguration(
        view: UIView.self,
        attributes: [
          Attr(value: UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
        ]));
    }
  }
  
  func test_component_withChild() {
    final class TestViewComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component] {
        return [
          TestChildComponent(nil, view: ViewConfiguration(
            view: UIView.self,
            attributes: [
              Attr(value: UIColor.blue, applicator: {(view, color) in view.backgroundColor = color })
            ]))
        ];
      }
      
      func size() -> CGSize {
        return CGSize(width: 50, height: 50);
      }
    }
    
    final class TestChildComponent: TypedComponent {
      typealias PropType = Void?
      
      func size() -> CGSize {
        return CGSize(width: 25, height: 25);
      }
    }
    
    snapshotTestComponent(CGSize(width: 100, height: 100), #function) {() -> Component in
      return TestViewComponent(nil, view: ViewConfiguration(
        view: UIView.self,
        attributes: [
          Attr(value: UIColor.red, applicator: {(view, color) in view.backgroundColor = color })
        ]));
    }
  }
  
  private func snapshotTestComponent(_ size: CGSize, _ identifier: String, factory: () -> Component) {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
    let scopeRoot = ScopeRoot(previousRoot: nil, listener: nil, stateUpdateMap: [:], factory: factory);
    
    let layout = scopeRoot.root.component().layout(constraint: view.bounds.size, tree: scopeRoot.root);
    
    scopeRoot.root.component().mount(parentView: view,
                                   layout: layout,
                                   position: CGPoint(x: 0, y: 0));
    
    FBSnapshotVerifyView(view, identifier: identifier);
  }
}
