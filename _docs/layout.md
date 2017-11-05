---
docid: layout
title: Layout
layout: docs
permalink: /docs/layout
---

## FlexboxComponent

Theodolite uses [Facebook Yoga](https://facebook.github.io/yoga/) as the default layout system. To use Flexbox to lay out your components, you simply implement `render()`, and return a `FlexboxComponent` as your child:

```swift
override func render() -> [Component] {
  return [FlexboxComponent {
   (options: FlexOptions(flexDirection: .column),
    children: [
     FlexChild(FooComponent { "Hello" },
               flexGrow: 1),
     FlexChild(BarComponent { "World" },
               margin: Edges(left: 20, right: 20, top: 10, bottom: 5))
    ])
  }]
}
```

This component is built to be similar to ComponentKit's CKFlexboxComponent, so if you've used ComponentKit before, you should know the basics of how to use it in Theodolite.

1. `FlexboxComponent` takes an options struct, and an array of flex children.
2. `FlexOptions` provides you with configuration for the container as a whole. There's lots of configuration options, which are covered in the Yoga docs.
3. Each child component is wrapped in a `FlexChild` struct, which provides per-component configuration of flex properties, like `flexGrow`, `flexShrink`, `margin`, `padding`, and `alignSelf`.

Most user interfaces can be achieved through judicious use of Flexbox. There's tons of tutorials online for Flexbox, so we won't cover the details here.

### Common problems

#### Text overflowing bounds

If your text is overflowing your bounds, most likely you need to set `flexShrink` on your text component.

#### I'm getting an assert for my flexbox component that there's a scope collision.

This isn't restricted to FlexboxComponent, but you'll most likely run into it in Flexbox. Basically, the framework is telling you that it can't tell your components apart. You need to annotate each child with a unique `key` value:

```swift
FooComponent(key: "Identifier") { "Hello World" }
```

## InsetComponent

As shown above, margin and padding are available in FlexChild nodes, however if you want a lighter-weight way to provide some spacing around a given component, you can use `InsetComponent`:

```swift
override func render() -> [Component] {
  return [InsetComponent {
    (insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
     component: FooComponent { "Hello World" }
  )}]
}

## SizeComponent

If you want to specify exactly the size of a child component, then you can use `SizeComponent` to provide a specific size:

```swift
override func render() -> [Component] {
  return [SizeComponent {
    (size: CGSize(width: 100, height: 100),
     component: FooComponent { "Hello World" })
  }]
}
```

## Custom Layout

You generally should avoid implementing a custom layout, however for certain classes of layouts, it's the only option. Check out the guide on [custom layout](http://theodolite.org/docs/custom-layout.html) for more info.
