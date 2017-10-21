//
//  CGSize+Hashable.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/21/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

extension CGSize : Hashable {
  public var hashValue: Int {
    return hashCombine(width, height)
  }
}
