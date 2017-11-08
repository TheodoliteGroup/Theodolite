---
docid: accessibility 
title: Accessibility
layout: docs
permalink: /docs/accessibility
---

Configuring views as accessibility elements is easy:

```swift
  public override func view() -> ViewConfiguration? {
    return ViewConfiguration(
      view: UIView.self,
      attributes: ViewOptions(
        isAccessibilityElement: true,
        accessibilityLabel: "Some Label"
      ).viewAttributes())
  }
```
