//
//  Sourcery.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/20/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

protocol AutoEquatable {}
protocol AutoHashable {}
protocol AutoLenses {}

/** This isn't really necessary, but I was playing with Sourcery, and thought it'd be fun to see what it'd look like. */
protocol AutoModel: AutoEquatable, AutoHashable, AutoLenses {}
