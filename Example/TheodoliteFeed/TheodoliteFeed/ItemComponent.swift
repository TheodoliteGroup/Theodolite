//
//  ItemComponent.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Theodolite

struct Actor {
  let name: String;
}

struct Item {
  let actor: Actor;
  
}

final class ItemComponent: TypedComponent {
  typealias PropType = Item;
}
