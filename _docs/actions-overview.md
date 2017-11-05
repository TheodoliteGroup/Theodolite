---
docid: actions-overview
title: Overview
layout: docs
permalink: /docs/actions-overview
---

## Actions

Actions provide a simple way for a child component to inform a parent component that something happened. For example:

```
FooComponent
 -> ButtonComponent
```

If FooComponent wants to know when the ButtonComponent is tapped, it can pass down an *action* which is received by the ButtonComponent in its props.

```
  ButtonComponent tapped -> call FooComponent's action
```

Note that Action is generic, and provides the capacity for providing data to the callee. Here's an example:

```swift
final class ButtonComponent: Component, TypedComponent {
 typealias PropType = Action<UITouch>

 func somethingHappened(touch: UITouch) {
   self.props().send(touch)
 }
}
```

## Handlers

`Handler` is a specialization of Action for a specific parent component. Handlers are constructed by parent components, but should never be exposed in props. Always put Actions in props instead, and callers will actually pass you a handler to that action instead.

Usage:

```swift
final class BarComponent: Component, TypedComponent {
 typealias PropType = Void?

 func actionMethod(touch: UITouch) {} // When ButtonComponent sends its action, this method will be invoked

 override func render() -> [Component] {
   return ButtonComponent { Handler(BarComponent.actionMethod) }
 }
}
```
