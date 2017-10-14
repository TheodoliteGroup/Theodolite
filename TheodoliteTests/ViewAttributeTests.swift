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
    let attr = Attr(value: 42, applicator: TestView.applicatorMethod)
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
    let attr = Attr(value: 42, applicator: TestView.applicatorMethod)
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
    let attr = Attr<TestView, Int>(value: 42) {(view: TestView, val: Int) in
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
    let attr = Attr<TestView, Int>(value: 42) {(view: TestView, val: Int) in
      view.applicatorMethod(val: val)
    }
    let view = TestView()
    
    attr.apply(view: view)
    
    XCTAssert(view.valIs42)
  }
}
