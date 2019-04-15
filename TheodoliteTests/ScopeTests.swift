//
//  ScopeTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/10/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

class ScopeTests: XCTestCase {
  
  /** Scope Handle tests */
  
  func test_whenBuildingTwoScopeHandles_eachGetsAUniqueIdentifier() {
    let scope1 = ScopeHandle(responder: ScopedResponder(), parentIdentifier: ScopeIdentifier(path: []), state: nil) { _,_ in }
    let scope2 = ScopeHandle(responder: ScopedResponder(), parentIdentifier: ScopeIdentifier(path: []), state: nil) { _,_ in }
    
    XCTAssertNotEqual(scope1.identifier, scope2.identifier)
  }
  
  func test_whenBuildingScopeHandleWithIdentifier_thatIdentifierIsSetOnScopeHandle() {
    let scope = ScopeHandle(responder: ScopedResponder(), identifier: ScopeIdentifier(path: [42]), state: nil) { _,_ in }
    XCTAssertEqual(scope.identifier, ScopeIdentifier(path: [42]))
  }
  
  /** Scope tests */
  
  func test_buildingScopeWithNoPreviousScope_buildsScopeWithComponent() {
    final class TestComponent: Component, TypedComponent {
      typealias PropType = Bool
    }
    
    let c = TestComponent( true )
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      parentIdentifier: ScopeIdentifier(path: []),
                      stateUpdateMap: [:])
    XCTAssert(scope.component() === c)
  }
  
  func test_buildingScopeWithNoPreviousScope_setsInitialStateOnComponent() {
    final class TestIntStateComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    let c = TestIntStateComponent( nil )
    
    let _ = Scope(listener: nil,
                  component: c,
                  previousScope: nil,
                  parentIdentifier: ScopeIdentifier(path: []),
                  stateUpdateMap: [:])
    
    XCTAssertEqual(c.state, c.initialState())
  }
  
  func test_buildingScopeWithPreviousScope_keepsIdentifiersForComponent() {
    final class TestIntStateComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    let c1 = TestIntStateComponent( nil )
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    let c2 = TestIntStateComponent( nil )
    
    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    XCTAssertEqual(scope1._handle.identifier, scope2._handle.identifier)
  }
  
  func test_buildingScopeWithPreviousScope_doesNotCallInitialState() {
    final class TestInitialStateCallComponent: Component, TypedComponent {
      
      typealias PropType = () -> ()
      typealias StateType = Int
      
      func initialState() -> Int {
        self.props()
        return 42
      }
    }
    
    var calledInitialState = false
    
    let initialStateClosure = {
      calledInitialState = true
    }
    
    let c1 = TestInitialStateCallComponent( initialStateClosure )
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    XCTAssert(calledInitialState)
    calledInitialState = false
    
    let c2 = TestInitialStateCallComponent( initialStateClosure )
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: scope1,
                  parentIdentifier: ScopeIdentifier(path: []),
                  stateUpdateMap: [:])
    
    XCTAssertFalse(calledInitialState)
  }
  
  func test_buildingScopeWithStateUpdateMap_andNilPreviousScope_doesNotUpdateState() {
    final class TestStateUpdateComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    let c1 = TestStateUpdateComponent( nil )
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    let c2 = TestStateUpdateComponent( nil )
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: nil,
                  parentIdentifier: ScopeIdentifier(path: []),
                  stateUpdateMap: [scope1._handle.identifier: 1000])
    
    XCTAssertEqual(c2.state, 42)
  }
  
  func test_buildingScopeWithStateUpdateMap_andPreviousScope_updatesState() {
    final class TestStateUpdateComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    let c1 = TestStateUpdateComponent( nil )
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    let c2 = TestStateUpdateComponent( nil )
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: scope1,
                  parentIdentifier: ScopeIdentifier(path: []),
                  stateUpdateMap: [scope1._handle.identifier: 1000])
    
    XCTAssertEqual(c2.state, 1000)
  }
  
  func test_buildingScopeForComponent_withChildren_createsChildComponent() {
    final class TestChildComponent: Component, TypedComponent {
      
      typealias PropType = Void?
    }
    
    final class TestParentComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      
      override func render() -> [Component] {
        return [TestChildComponent( nil )]
      }
    }
    
    let c = TestParentComponent( nil )
    
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      parentIdentifier: ScopeIdentifier(path: []),
                      stateUpdateMap: [:])
    
    XCTAssert(type(of:scope._children[0].component()) == TestChildComponent.self)
  }
  
  func test_buildingScopeForComponent_withChildrenWhoHaveState_createsChildComponentWithState() {
    final class TestChildComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    final class TestParentComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      
      override func render() -> [Component] {
        return [TestChildComponent( nil )]
      }
    }
    
    let c = TestParentComponent( nil )
    
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      parentIdentifier: ScopeIdentifier(path: []),
                      stateUpdateMap: [:])
    
    XCTAssertEqual((scope._children[0].component() as! TestChildComponent).state, 42)
  }
  
  func test_buildingScopeForComponent_withChildrenWhoHaveState_andStateUpdateForChild_createsChildComponentWithUpdatedState() {
    final class TestChildComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int {
        return 42
      }
    }
    
    final class TestParentComponent: Component, TypedComponent {
      
      typealias PropType = Void?
      
      override func render() -> [Component] {
        return [TestChildComponent( nil )]
      }
    }
    
    let c1 = TestParentComponent( nil )
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [:])
    
    let c2 = TestParentComponent( nil )
    
    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       parentIdentifier: ScopeIdentifier(path: []),
                       stateUpdateMap: [scope1._children[0]._handle.identifier: 1000])
    
    XCTAssertEqual((scope2._children[0].component() as! TestChildComponent).state, 1000)
  }
  
  /** Scope root tests */
  
  func test_buildingScopeRootForComponent_withUniqueKeys_haveUniqueIdentifiers() {
    final class TestComponent: Component, TypedComponent {
      typealias PropType = Bool
    }
    let scope1 = ScopeRoot(previousRoot: nil,
                           listener: nil,
                           stateUpdateMap: [:]) {
                            () -> Component in
                            return TestComponent(key: "key1", false)
    }
    
    let scope2 = ScopeRoot(previousRoot: scope1,
                           listener: nil,
                           stateUpdateMap: [:]) {
                            () -> Component in
                            return TestComponent(key: "key2", false)
    }
    
    XCTAssertNotEqual(scope1.root._handle.identifier, scope2.root._handle.identifier)
  }

  func test_buildingScopeRootForComponent_traversesThatHierarchy_whenTraverseCalled() {
    final class TestComponent: Component, TypedComponent {
      typealias PropType = Bool
    }
    let scope1 = ScopeRoot(previousRoot: nil,
                           listener: nil,
                           stateUpdateMap: [:]) {
                            () -> Component in
                            return TestComponent(key: "key1", false)
    }

    var traversed: Component? = nil
    scope1.traverse { (c) in
      XCTAssertNil(traversed)
      traversed = c
    }

    XCTAssert(traversed === scope1.root._component)
  }
}
