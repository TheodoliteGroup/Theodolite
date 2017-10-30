//
//  TextKitView.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public  final class TextKitView: UIView {
  var attributes: TextKitAttributes? = nil {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  public override func draw(_ rect: CGRect) {
    guard let attributes = self.attributes else {
      return
    }
    let renderer = TextKitRenderer.renderer(attributes: attributes,
                                            constrainedSize: self.bounds.size)
    renderer.drawInContext(graphicsContext: UIGraphicsGetCurrentContext()!,
                           bounds: rect)
  }
}
