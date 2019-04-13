//
//  View.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public struct ViewConfiguration: Equatable, Hashable {
  let view: UIView.Type
  let attributes: [Attribute]
  
  public init(view: UIView.Type, attributes: [Attribute]) {
    self.view = view
    self.attributes = attributes
    assert(findDuplicates(attributes: attributes).count == 0,
           "Duplicate attributes. You must provide identifiers for: \(findDuplicates(attributes: attributes))")
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.view.hash())
    for attr in self.attributes {
      hasher.combine(attr)
    }
  }
  
  func applyToView(v: UIView) {
    assert(type(of: v) == view)
    let appliedAttributes: ViewConfiguration? = getAssociatedObject(object: v,
                                                                    associativeKey: &kAppliedAttributesKey)
    if appliedAttributes == self {
      return
    }
    
    if let needsUnapplication = appliedAttributes {
      for attr in needsUnapplication.attributes {
        attr.unapply(view: v)
      }
    }
    
    for attr in self.attributes {
      attr.apply(view: v)
    }
    setAssociatedObject(object: v,
                        value: self,
                        associativeKey: &kAppliedAttributesKey)
  }
  
  func buildView() -> UIView {
    let v = self.view.init()
    self.applyToView(v: v)
    return v
  }
  
  func isEquivalent(other: ViewConfiguration) -> Bool {
    if view != other.view {
      return false
    }
    
    if (attributes.count != other.attributes.count) {
      return false
    }
    
    for (i, attr) in attributes.enumerated() {
      if (!attr.isEquivalent(other: other.attributes[i])) {
        return false
      }
    }
    
    return true
  }
  
  public struct AttributeShape: Equatable, Hashable {
    let config: ViewConfiguration
  }
}

public func ==(lhs: ViewConfiguration, rhs: ViewConfiguration) -> Bool {
  return lhs.view === rhs.view
    && lhs.attributes == rhs.attributes
}

private func findDuplicates(attributes: [Attribute]) -> [Attribute] {
  var set: Set<Attribute> = Set()
  var duplicates: [Attribute] = []
  for attr in attributes {
    if set.contains(attr) {
      duplicates.append(attr)
    } else {
      set.insert(attr);
    }
  }
  return duplicates
}

var kAppliedAttributesKey: Void?
