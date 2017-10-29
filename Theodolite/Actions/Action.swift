//
//  Action.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 Inspired by http://blog.scottlogic.com/2015/02/05/swift-events.html
 */

/**
 Actions provide a simple way for a child component to inform a parent component that something happened. For example:
 
 FooComponent
   -> ButtonComponent
 
 If FooComponent wants to know when the ButtonComponent is tapped, it can pass down an *action* which is received by
 the ButtonComponent in its props.
 
   ButtonComponent tapped -> call FooComponent's action
 
 Note that Action is generic, and provides the capacity for providing data to the callee. Here's an example:
 
 final class ButtonComponent: TypedComponent {
   typealias PropType = Action<UITouch>
 
   func somethingHappened(touch: UITouch) {
     self.props().send(touch)
   }
 }
 */
public class Action<Arg> {
  public func send(_ argument: Arg) {
    // No-op
  }
}

/**
 Handler is a specialization of Action for a specific parent component. Handlers are constructed by parent components,
 but should never be exposed in props. Always put Actions in props instead, and callers will actually pass you a handler
 to that action instead.
 
 Usage:
 
 final class BarComponent: TypedComponent {
   typealias PropType = Void?
 
   func actionMethod(touch: UITouch) {} // When ButtonComponent sends its action, this method will be invoked
 
   func render() -> [Component] {
     return ButtonComponent { Handler(BarComponent.actionMethod) }
   }
 }
 */
public class Handler<Target: AnyObject, Arg>: Action<Arg> {
  weak var target: Target?
  let handler: (Target) -> (Arg) -> ()
  
  public init(_ target: Target, _ handler: @escaping (Target) -> (Arg) -> ()) {
    self.target = target
    self.handler = handler
  }
  
  public override func send(_ argument: Arg) {
    if let t = target {
      handler(t)(argument)
    }
  }
}
