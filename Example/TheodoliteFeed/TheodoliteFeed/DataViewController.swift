//
//  DataViewController.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/13/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit
import Theodolite

class DataViewController: UIViewController {


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let hostingView: ComponentHostingView = ComponentHostingView { () -> Component in
      return StackComponent([
        LabelComponent((string: "Lorem ipsum dolor sit amet, cu cum maiorum moderatius, cum ne soluta possit adipisci, no aliquando urbanitas constituam pro. Ne eam probatus constituto, postea lucilius tacimates at qui. Id sed munere mandamus, id his justo salutatus constituam. Pri timeam facilisi ut, eam ut numquam consectetuer, etiam inermis nam et. Eos ex quando epicuri. At duis decore alienum pri.", font: UIFont.systemFont(ofSize: 20), color: UIColor.black)),
        LabelComponent((string: "Hello World", font: UIFont.systemFont(ofSize: 14), color: UIColor.blue))
        ])
    }
    hostingView.frame = self.view.bounds
    self.view.addSubview(hostingView)
  }


}

