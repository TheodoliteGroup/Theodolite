//
//  ScopeTests.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/10/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import XCTest
@testable import Theodolite

final class TestScopeComponent<T, S>: TypedComponent {
  typealias PropType = T
  typealias StateType = S
}

class ScopeTests: XCTestCase {
  
  /** Scope Handle tests */
  
  func test_whenBuildingTwoScopeHandles_eachGetsAUniqueIdentifier() {
    let scope1 = ScopeHandle(state: nil) { _,_ in }
    let scope2 = ScopeHandle(state: nil) { _,_ in }
    
    XCTAssertNotEqual(scope1.identifier, scope2.identifier)
  }
  
  func test_whenBuildingScopeHandleWithIdentifier_thatIdentifierIsSetOnScopeHandle() {
    let scope = ScopeHandle(identifier: 42, state: nil) { _,_ in }
    XCTAssertEqual(scope.identifier, 42)
  }
  
  /** Scope tests */
  
  func test_buildingScopeWithNoPreviousScope_buildsScopeWithComponent() {
    let c = TestScopeComponent<Bool, Void?>(true)
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      stateUpdateMap: [:])
    XCTAssert(scope.component() === c)
  }
  
  func test_buildingScopeWithNoPreviousScope_setsInitialStateOnComponent() {
    final class TestIntStateComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    let c = TestIntStateComponent()
    
    let _ = Scope(listener: nil,
                  component: c,
                  previousScope: nil,
                  stateUpdateMap: [:])
    
    XCTAssertEqual(c.state(), c.initialState())
  }
  
  func test_buildingScopeWithPreviousScope_keepsIdentifiersForComponent() {
    final class TestIntStateComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    let c1 = TestIntStateComponent()
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       stateUpdateMap: [:])
    
    let c2 = TestIntStateComponent()
    
    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       stateUpdateMap: [:])
    
    XCTAssertEqual(scope1._handle.identifier, scope2._handle.identifier)
  }
  
  func test_buildingScopeWithPreviousScope_doesNotCallInitialState() {
    final class TestInitialStateCallComponent: TypedComponent {
      typealias PropType = () -> ()
      typealias StateType = Int
      
      func initialState() -> Int? {
        self.props()()
        return 42
      }
    }
    
    var calledInitialState = false
    
    let initialStateClosure = {
      calledInitialState = true
    }
    
    let c1 = TestInitialStateCallComponent(initialStateClosure)
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       stateUpdateMap: [:])
    
    XCTAssert(calledInitialState)
    calledInitialState = false
    
    let c2 = TestInitialStateCallComponent(initialStateClosure)
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: scope1,
                  stateUpdateMap: [:])
    
    XCTAssertFalse(calledInitialState)
  }
  
  func test_buildingScopeWithStateUpdateMap_andNilPreviousScope_doesNotUpdateState() {
    final class TestStateUpdateComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    let c1 = TestStateUpdateComponent()
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       stateUpdateMap: [:])
    
    let c2 = TestStateUpdateComponent()
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: nil,
                  stateUpdateMap: [scope1._handle.identifier: 1000])
    
    XCTAssertEqual(c2.state(), 42)
  }
  
  func test_buildingScopeWithStateUpdateMap_andPreviousScope_updatesState() {
    final class TestStateUpdateComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    let c1 = TestStateUpdateComponent()
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       stateUpdateMap: [:])
    
    let c2 = TestStateUpdateComponent()
    
    let _ = Scope(listener: nil,
                  component: c2,
                  previousScope: scope1,
                  stateUpdateMap: [scope1._handle.identifier: 1000])
    
    XCTAssertEqual(c2.state(), 1000)
  }
  
  func test_buildingScopeForComponent_withChildren_createsChildComponent() {
    final class TestChildComponent: TypedComponent {
      typealias PropType = Void?
    }
    
    final class TestParentComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component?] {
        return [TestChildComponent()]
      }
    }
    
    let c = TestParentComponent()
    
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      stateUpdateMap: [:])
    
    XCTAssert(type(of:scope._children[0]!.component()) == TestChildComponent.self)
  }
  
  func test_buildingScopeForComponent_withChildrenWhoHaveState_createsChildComponentWithState() {
    final class TestChildComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    final class TestParentComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component?] {
        return [TestChildComponent()]
      }
    }
    
    let c = TestParentComponent()
    
    let scope = Scope(listener: nil,
                      component: c,
                      previousScope: nil,
                      stateUpdateMap: [:])
    
    XCTAssertEqual((scope._children[0]?.component() as! TestChildComponent).state(), 42)
  }
  
  func test_buildingScopeForComponent_withChildrenWhoHaveState_andStateUpdateForChild_createsChildComponentWithUpdatedState() {
    final class TestChildComponent: TypedComponent {
      typealias PropType = Void?
      typealias StateType = Int
      
      func initialState() -> Int? {
        return 42
      }
    }
    
    final class TestParentComponent: TypedComponent {
      typealias PropType = Void?
      
      func render() -> [Component?] {
        return [TestChildComponent()]
      }
    }
    
    let c1 = TestParentComponent()
    
    let scope1 = Scope(listener: nil,
                       component: c1,
                       previousScope: nil,
                       stateUpdateMap: [:])
    
    let c2 = TestParentComponent()
    
    let scope2 = Scope(listener: nil,
                       component: c2,
                       previousScope: scope1,
                       stateUpdateMap: [scope1._children[0]!._handle.identifier: 1000])
    
    XCTAssertEqual((scope2._children[0]!.component() as! TestChildComponent).state(), 1000)
  }
  
  /** Scope root tests */
  
  func test_buildingScopeRootForComponent_withUniqueKeys_haveUniqueIdentifiers() {
    let scope1 = ScopeRoot(previousRoot: nil,
                           listener: nil,
                           stateUpdateMap: [:]) {
                            () -> Component in
                            return TestScopeComponent<Void?, Void?>(nil, key: "key1")
    }
    
    let scope2 = ScopeRoot(previousRoot: scope1,
                           listener: nil,
                           stateUpdateMap: [:]) {
                            () -> Component in
                            return TestScopeComponent<Void?, Void?>(nil, key: "key2")
    }
    
    XCTAssertNotEqual(scope1.root._handle.identifier, scope2.root._handle.identifier)
  }
}
