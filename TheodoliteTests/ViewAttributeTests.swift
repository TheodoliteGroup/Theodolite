//
//  ViewAttributeTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ViewAttributeTests: XCTestCase {
  func test_applyingAttr_withCurriedForm_callsMethod_whenAppliedToView() {
    final class TestView: UIView {
      var calledMethod = false
      func applicatorMethod(val: Int) {
        self.calledMethod = true
      }
    }
    let attr = Attr(42, applicator: TestView.applicatorMethod)
    let view = TestView()
    
    attr.apply(view: view)
    
    XCTAssert(view.calledMethod)
  }
  
  func test_applyingAttr_withCurriedForm_callsMethod_withArgument_whenAppliedToView() {
    final class TestView: UIView {
      var valIs42 = false
      func applicatorMethod(val: Int) {
        self.valIs42 = val == 42
      }
    }
    let attr = Attr(42, applicator: TestView.applicatorMethod)
    let view = TestView()
    
    attr.apply(view: view)
    
    XCTAssert(view.valIs42)
  }
  
  func test_applyingAttr_withNonCurriedForm_callsMethod_whenAppliedToView() {
    final class TestView: UIView {
      var calledMethod = false
      func applicatorMethod(val: Int) {
        self.calledMethod = true
      }
    }
    let attr = Attr<TestView, Int>(42) {(view: TestView, val: Int) in
      view.applicatorMethod(val: val)
    }
    let view = TestView()
    
    attr.apply(view: view)
    
    XCTAssert(view.calledMethod)
  }
  
  func test_applyingAttr_withNonCurriedForm_callsMethod_withArgument_whenAppliedToView() {
    final class TestView: UIView {
      var valIs42 = false
      func applicatorMethod(val: Int) {
        self.valIs42 = val == 42
      }
    }
    let attr = Attr<TestView, Int>(42) {(view: TestView, val: Int) in
      view.applicatorMethod(val: val)
    }
    let view = TestView()
    
    attr.apply(view: view)
    
    XCTAssert(view.valIs42)
  }
  
  func test_attrWithCurriedForm_andEqualParameters_areEqual() {
    final class TestView: UIView {
      var calledMethod = false
      func applicatorMethod(val: Int) {
        self.calledMethod = true
      }
    }
    let attr = Attr(42, applicator: TestView.applicatorMethod)
    let attr2 = Attr(42, applicator: TestView.applicatorMethod)
    
    XCTAssertEqual(attr, attr2);
  }
  
  func test_attrWithCurriedForm_andNonEqualParameters_areNotEqual() {
    final class TestView: UIView {
      var calledMethod = false
      func applicatorMethod(val: Int) {
        self.calledMethod = true
      }
    }
    let attr = Attr(43, applicator: TestView.applicatorMethod)
    let attr2 = Attr(42, applicator: TestView.applicatorMethod)
    
    XCTAssertNotEqual(attr, attr2);
  }
  
  func test_attrWithCurriedForm_andAttrWithoutCurriedForm_areNotEqual() {
    final class TestView: UIView {
      var calledMethod = false
      func applicatorMethod(val: Int) {
        self.calledMethod = true
      }
    }
    let attr = Attr(42, applicator: TestView.applicatorMethod)
    let attr2 = Attr<TestView, Int>(42) {(view: TestView, val: Int) in
      view.backgroundColor = nil;
      view.applicatorMethod(val: val)
    }
    
    XCTAssertNotEqual(attr, attr2);
  }
}
