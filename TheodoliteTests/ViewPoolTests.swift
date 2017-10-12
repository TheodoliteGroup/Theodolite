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
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: []);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    
    XCTAssert(retrievedView!.isKind(of: UILabel.self));
  }
  
  func test_retrievingViewWithViewConfiguration_afterReset_returnsSameView() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: []);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    
    pool.reset();
    
    let retrievedView2 = pool.retrieveView(parent: parent, config: config);
    
    XCTAssertEqual(retrievedView, retrievedView2);
  }
  
  func test_retrievingViewWithViewConfiguration_withoutReset_returnsDifferentView() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: []);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    
    let retrievedView2 = pool.retrieveView(parent: parent, config: config);
    
    XCTAssertNotEqual(retrievedView, retrievedView2);
  }
  
  func test_retrievingViewWithViewConfiguration_andCallingReset_doesNotHideView() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: []);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    
    pool.reset();
    
    XCTAssert(!(retrievedView?.isHidden)!);
  }
  
  func test_retrievingViewWithViewConfiguration_twice_andCallingReset_hidesUnRetrievedView() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: []);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    let retrievedView2 = pool.retrieveView(parent: parent, config: config);
    
    pool.reset();
    
    let retrievedView3 = pool.retrieveView(parent: parent, config: config);
    
    pool.reset();
    
    XCTAssertEqual(retrievedView, retrievedView3);
    XCTAssert((retrievedView2?.isHidden)!);
    XCTAssert(!(retrievedView?.isHidden)!);
  }
  
  func test_retrievingViewWithViewConfiguration_appliesAttributes() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(value: UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val;
        }
      ]);
    
    let retrievedView = pool.retrieveView(parent: parent, config: config);
    
    XCTAssertEqual(retrievedView?.backgroundColor, UIColor.red);
  }
  
  func test_retrievingViewWithViewConfiguration_thenRetrievingItAgain_updatesAppliedValues() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(value: UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val;
        }
      ]);
    
    let _ = pool.retrieveView(parent: parent, config: config);
    
    pool.reset();
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(value: UIColor.blue) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val;
        }
      ]);
    
    let retrievedView2 = pool.retrieveView(parent: parent, config: config2);
    
    XCTAssertEqual(retrievedView2?.backgroundColor, UIColor.blue);
  }
  
  func test_retrievingView_performance() {
    var pool = ViewPool();
    
    let parent = UIView();
    
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(value: UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val;
        }
      ]);
    
    self.measure {
      for _ in 1...10000 {
        let _ = pool.retrieveView(parent: parent, config: config);
        pool.reset();
      }
    }
  }
}
