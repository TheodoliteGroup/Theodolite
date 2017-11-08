---
docid: snapshot-testing
title: Snapshot Testing
layout: docs
permalink: /docs/unit-testing.html
---

## Theodolite ❤️ Snapshot Testing

It's super easy to create snapshot tests for Components!

```swift
func test_singleString() {
  snapshotTestComponent(self, CGSize(width: 100, height: 100), #function) {() -> Component in
    return LabelComponent {
      ("hello",
       LabelComponent.Options())
    }
  }
}
```

You just need to define the helper method:

```swift
func snapshotTestComponent(_ testCase: FBSnapshotTestCase, _ size: CGSize, _ identifier: String, mountVisibleOnly: Bool = false, factory: () -> Component) {
  let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
  let scopeRoot = ScopeRoot(previousRoot: nil, listener: nil, stateUpdateMap: [:], factory: factory)
  
  let layout = scopeRoot.root.component().layout(constraint: SizeRange(max: view.bounds.size),
                                                 tree: scopeRoot.root)
  
  MountRootLayout(view: view,
                  layout: layout,
                  position: CGPoint(x: 0, y: 0),
                  incrementalContext: IncrementalMountContext(),
                  mountVisibleOnly: mountVisibleOnly)
  
  testCase.FBSnapshotVerifyView(view, identifier: identifier)
}
```
