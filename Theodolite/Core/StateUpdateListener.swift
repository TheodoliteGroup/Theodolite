//
//  StateUpdateListener.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

public protocol StateUpdateListener: class {
  func receivedStateUpdate(identifier: Int32, update: Any?);
}
