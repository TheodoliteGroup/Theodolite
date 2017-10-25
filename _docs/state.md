---
docid: state
title: State
layout: docs
permalink: /docs/state
---

A Theodolite component can contain two types of data:

*  **props**: passed down from parent and cannot change during a component's lifecycle.
*  **state**: encapsulates implementation details that are managed by the component and is opaque to the parent.

A common example for when State is needed is rendering a checkbox. The component renders different views for the checked and unchecked states, but this is an internal detail of the checkbox component that the parent doesn't need to be aware of.

## Declaring component state
You can define State on a Component by using the StateType `typealias` in your `TypedComponent`, similarly to how you would define a Prop.

Defining state elements is enabled on the lifecycle methods of Layout Specs and Mount Specs.

```
final class CheckboxComponent: TypedComponent {
  typealias PropType = Bool
  typealias StateType = Bool?

  func render() -> [Component] {
    // State will initially be nil, unless you implement initialState()
    return [
      InternalCheckboxComponent {
        (checked: self.state() ?? self.props(),
          action: Handler(self, CheckboxComponent.actionMethod))
      }
    ]
  }

  func actionMethod(checked: Bool) {
    self.updateState(checked)
  }
}
```

The `self.updateState()` call will force a re-render of the component hierarchy, and on the next generation, the new state will be available in `render()`.

NOTE: **`self.updateState()` is not applied synchronously. It is always delayed at least one runloop turn to batch updates.**

## Initializing a state value

To set an initial value for a state, just implement initialState(), and return the initial state that the component should use. This is only called for the first generation for a logical component.

```
func initialState() -> Bool? { // Return value is StateType?
  // Let's say there's a initiallyChecked value in our props, we can use that
  // value here to force the component into that state on initial render.
  return self.props().initiallyChecked
}
```

## State isn't available until render()

You may not access `self.state()` on your component until the `render()` method is called. The framework will assert if you attempt to access it before this time.

## Immutability

Because of [background layout](/docs/asynchronous-layout), `state()` can be accessed at anytime by multiple threads. To ensure thread safety, `State` objects should be immutable (and if for some rare reason this is not possible, then at least thread safe). The simplest solution is to express your state in terms of primitives since primitives are by definition immutable.
