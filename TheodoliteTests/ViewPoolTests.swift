//
//  ViewPoolTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ViewPoolTests: XCTestCase {
  func test_retrievingViewWithViewConfiguration_returnsViewWithCorrectClass() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    
    XCTAssert(retrievedView!.isKind(of: UILabel.self))
  }
  
  func test_retrievingViewWithViewConfiguration_afterReset_returnsSameView() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    pool.checkinView(component: component, view: retrievedView!)
    
    pool.reset()
    
    let retrievedView2 = pool.checkoutView(component: component, parent: parent, config: config)
    
    XCTAssertEqual(retrievedView, retrievedView2)
  }
  
  func test_retrievingViewWithViewConfiguration_withoutReset_returnsDifferentView() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    
    let retrievedView2 = pool.checkoutView(component: component, parent: parent, config: config)
    
    XCTAssertNotEqual(retrievedView, retrievedView2)
  }
  
  func test_retrievingViewWithViewConfiguration_andCallingReset_doesNotHideView() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    
    pool.reset()
    
    XCTAssert(!(retrievedView?.isHidden)!)
  }
  
  func test_retrievingViewWithViewConfiguration_twice_andCallingReset_hidesUnRetrievedView() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    let retrievedView2 = pool.checkoutView(component: component, parent: parent, config: config)
    
    pool.checkinView(component: component, view: retrievedView!)
    pool.checkinView(component: component, view: retrievedView2!)
    pool.reset()
    
    let retrievedView3 = pool.checkoutView(component: component, parent: parent, config: config)
    
    pool.reset()
    
    XCTAssertEqual(retrievedView, retrievedView3)
    XCTAssert((retrievedView2?.isHidden)!)
    XCTAssert(!(retrievedView?.isHidden)!)
    XCTAssert(parent.subviews.count == 2)
  }
  
  func test_retrievingViewWithViewConfiguration_appliesAttributes() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    let component = ViewComponent {config}
    
    let retrievedView = pool.checkoutView(component: component, parent: parent, config: config)
    
    XCTAssertEqual(retrievedView?.backgroundColor, UIColor.red)
  }
  
  func test_retrievingViewWithViewConfiguration_thenRetrievingItAgain_updatesAppliedValues() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    let component = ViewComponent {config}
    
    let view = pool.checkoutView(component: component, parent: parent, config: config)
    pool.checkinView(component: component, view: view!)
    pool.reset()
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.blue) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    let retrievedView2 = pool.checkoutView(component: component, parent: parent, config: config2)
    
    XCTAssertEqual(retrievedView2?.backgroundColor, UIColor.blue)
  }
  
  func test_retrievingView_performance() {
    let pool = ViewPool()
    
    let parent = UIView()
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    let component = ViewComponent {config}
    
    self.measure {
      for _ in 1...10000 {
        let view = pool.checkoutView(component: component, parent: parent, config: config)
        pool.checkinView(component: component, view: view!)
        pool.reset()
      }
    }
  }
}
