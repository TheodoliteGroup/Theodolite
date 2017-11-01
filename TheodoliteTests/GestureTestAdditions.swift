//
//  GestureTestAdditions.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 11/1/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

/**
 Taken from @ondrej in https://stackoverflow.com/questions/14094691/uitapgesturerecognizer-programmatically-trigger-a-tap-in-my-view
 */

// Return type alias
public typealias TargetActionInfo = [(target: AnyObject, action: Selector)]

extension  UIGestureRecognizer {

  // MARK: Retrieving targets from gesture recognizers

  /// Returns all actions and selectors for a gesture recognizer
  /// This method uses private API's and will most likely cause your app to be rejected if used outside of your test target
  /// - Returns: [(target: AnyObject, action: Selector)] Array of action/selector tuples
  public func getTargetInfo() -> TargetActionInfo {
    var targetsInfo: TargetActionInfo = []

    if let targets = self.value(forKeyPath: "_targets") as? [NSObject] {
      for target in targets {
        // Getting selector by parsing the description string of a UIGestureRecognizerTarget
        let selectorString = String.init(describing: target).components(separatedBy: ", ").first!.replacingOccurrences(of: "(action=", with: "")
        let selector = NSSelectorFromString(selectorString)

        // Getting target from iVars
        let targetActionPairClass: AnyClass = NSClassFromString("UIGestureRecognizerTarget")!
        let targetIvar: Ivar = class_getInstanceVariable(targetActionPairClass, "_target")
        let targetObject: AnyObject = object_getIvar(target, targetIvar) as AnyObject

        targetsInfo.append((target: targetObject, action: selector))
      }
    }

    return targetsInfo
  }

  /// Executes all targets on a gesture recognizer
  public func execute() {
    let targetsInfo = self.getTargetInfo()
    for info in targetsInfo {
      info.target.performSelector(onMainThread: info.action, with: self, waitUntilDone: true)
    }
  }

}
