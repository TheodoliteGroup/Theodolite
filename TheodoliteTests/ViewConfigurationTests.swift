//
//  ViewConfigurationTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ViewConfigurationTests: XCTestCase {
  func test_whenBuildingViewConfiguration_withViewType_andNoAttributes_buildView_returnsViewType() {
    let config = ViewConfiguration(view: UILabel.self, attributes: [])
    let view = config.buildView()
    XCTAssert(view.isKind(of: UILabel.self))
  }
  
  func test_viewConfigurationWithSingleAttributes_buildView_appliesAttribute() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    let view = config.buildView()
    XCTAssert(view.backgroundColor == UIColor.red)
  }
  
  func test_whenRebuildingView_withDifferentViewConfig_newAttributesApplied() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    let view = config.buildView()
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.blue) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    config2.applyToView(v: view)
    
    XCTAssert(view.backgroundColor == UIColor.blue)
  }
  
  func test_twoViewConfigurations_withIdenticalProperties_areEqual() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    XCTAssertEqual(config, config2)
  }

  func test_twoViewConfigurations_withIdenticalProperties_areEquivalent() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])

    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])

    XCTAssert(config.isEquivalent(other: config2))
  }
  
  func test_twoViewConfigurations_withIdenticalProperties_haveIdenticalHashes() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    XCTAssertEqual(config.hashValue, config2.hashValue)
  }
  
  func test_twoViewConfigurations_withDifferentProperties_areNotEqual() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.red) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.blue) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])
    
    XCTAssertNotEqual(config, config2)
  }

  func test_twoViewConfigurations_withDifferentAttributes_areNotEquivalent() {
    let config = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, Bool>(true) {(view: UILabel, val: Bool) in
          view.isUserInteractionEnabled = val
        }
      ])

    let config2 = ViewConfiguration(
      view: UILabel.self,
      attributes: [
        Attr<UILabel, UIColor>(UIColor.blue) {(view: UILabel, val: UIColor) in
          view.backgroundColor = val
        }
      ])

    XCTAssert(!config.isEquivalent(other: config2))
  }
}
