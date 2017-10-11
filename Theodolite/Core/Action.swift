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

class Action<Arg> {
  func send(_ argument: Arg) {
    // No-op
  }
}

class Handler<Target: AnyObject, Arg>: Action<Arg> {
  weak var target: Target?
  let handler: (Target) -> (Arg) -> ()
  
  init(target: Target, handler: @escaping (Target) -> (Arg) -> ()) {
    self.target = target
    self.handler = handler
  }
  
  override func send(_ argument: Arg) {
    if let t = target {
      handler(t)(argument);
    }
  }
}
