//
//  InsetComponentSnapshotTests.swift
//  TheodoliteTests
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import FBSnapshotTestCase
import Flexbox
@testable import Theodolite

class LabelComponentSnapshotTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func test_singleString() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello",
         LabelComponent.Options())
      )
    }
  }
  
  func test_longString() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello, my name is Oliver, and this is Theodolite. This string should truncate.",
         LabelComponent.Options())
      )
    }
  }
  
  func test_longString_withLineBreakMode() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello, my name is Oliver, and this is Theodolite. This string should wrap.",
         LabelComponent.Options(
          lineBreakMode: NSLineBreakMode.byWordWrapping,
          maximumNumberOfLines: 0
        ))
      )
    }
  }
  
  func test_longString_withLineBreakMode_andTwoMaxLines() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello, my name is Oliver, and this is Theodolite. This string should wrap.",
         LabelComponent.Options(
          lineBreakMode: NSLineBreakMode.byWordWrapping,
          maximumNumberOfLines: 2
        ))
      )
    }
  }
  
  func test_singleString_withTextColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello",
         LabelComponent.Options(
          textColor: UIColor.blue
        ))
      )
    }
  }
  
  func test_singleString_withFont() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello",
         LabelComponent.Options(
          font: UIFont(name: "Georgia", size: 20)!
        ))
      )
    }
  }
  
  func test_singleString_withTextAlignment() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return SizeComponent( // unless forced to consume all the space, the text component won't by default use it all
        (size: CGSize(width: 100, height: 100),
         component:
          LabelComponent(
            ("hello",
             LabelComponent.Options(
              textAlignment: NSTextAlignment.right
            )))))
    }
  }
  
  func test_singleString_withBGColor() {
    snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
      return LabelComponent(
        ("hello",
         LabelComponent.Options(
          view: ViewOptions(backgroundColor: UIColor.blue),
          textColor: UIColor.white
        ))
      )
    }
  }
}
