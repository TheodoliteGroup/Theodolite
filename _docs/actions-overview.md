---
docid: actions-overview
title: Actions
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

## Appendix: Scoped Responders

Components are constantly re-generated. This makes capturing specific components for actions difficult for actions that are the result of an asynchronous task. Network responses are a good example of where an old captured component may no longer be valid when the action is actually fired. A new component generation could have been generated while the network request is processing.

This is why we have a concept of scoped responders in Theodolite. Scoped responders are shared by all generations of a component, and provide a window into the "current" component.
