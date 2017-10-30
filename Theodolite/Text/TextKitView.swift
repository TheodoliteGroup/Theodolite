//
//  TextKitView.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/29/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

public  final class TextKitView: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
