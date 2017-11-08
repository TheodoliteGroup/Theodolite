---
docid: view-flattening
title: View Flattening
layout: docs
permalink: /docs/view-flattening
---

## Component != View

Components are not subclasses of UIViews. They're created and laid out off the main thread. This means that you can have very deep component hierarchies to control layout in a hierarchicial manner without incurring the costs of a deep view hierarchy.

This is best illustrated:

<img src="http://theodolite.org/static/images/flatter-feed-hierarchy.png" alt="A flatter hierarchy" style="width: 250px;"/>

In traditional UIViews, you would either have to create a fairly confusing set of autolayout constraints to achieve this layout, or you'd have several levels of subviews. With Theodolite, this hierarchy is limited to only the views that are absolutely necessary.

Component hierarchies separate layout from display, which makes extraneous views unnecessary.

### How do I not create a view?

Components expose the `view()` function, which returns a view configuration:

```swift
public override func view() -> ViewConfiguration? {
  return ViewConfiguration(view: UILabel.self,
                           attributes: [])
}
```

If you return `nil` from this method, then no view will be created for your component:

```swift
public override func view() -> ViewConfiguration? {
  return nil
}
```
