---
docid: custom-layout
title: Custom Layout
layout: docs
permalink: /docs/custom-layout.html
---

## Custom layout

Theodolite provides you with most of the tools you'll probably need to avoid writing your own layout, however if you do need to write some layout code, you can implement the `layout()` function on your component.

### Simple sizing

Here's a small example using a label component:

```swift
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let size = self.attributedString().boundingRect(
      with: constraint,
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil)
    return Layout(component: self,
                  size: CGSize(
                    width: ceil(size.width),
                    height: ceil(size.height)),
                  children: [])
  }
```

There are a few things going on here:

1. You're passed the `constraint`, which is the maximum renderable size. Note: `NaN` values imply that there is no constraint on the x or y axis.
2. You're passed the component tree from the `render()` pass. This is a protocolized tree structure that you may use to traverse your children components.

### Layout with children

The above label example didn't have any chidren components, but if you return any children in `render()`, you're going to need to properly render and position your children.

Here's an example from `ScrollComponent`:

```swift
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let direction = self.props().direction
    let children = tree.children().map { (childTree: ComponentTree) -> LayoutChild in
      return LayoutChild(
        layout:childTree
          .component()
          .layout(constraint:
            direction == UICollectionViewScrollDirection.vertical
              ? CGSize(width: constraint.width,
                       height: nan("unconstrained"))
              : CGSize(width: nan("unconstrained"),
                       height: constraint.height),
                  tree: childTree),
        position: CGPoint(x: 0, y: 0))
    }
    
    let contentRect = children.reduce(
      CGRect(x: 0, y: 0, width: 0, height: 0),
      { (unionRect, layoutChild) -> CGRect in
        return unionRect.union(CGRect(origin: layoutChild.position,
                                      size: layoutChild.layout.size))
    })
    
    return Layout(
      component: self,
      size: direction == UICollectionViewScrollDirection.vertical
        ? CGSize(width: contentRect.size.width, height: constraint.height)
        : CGSize(width: constraint.width, height: contentRect.size.height),
      children: children,
      extra: contentRect.size)
  }
```

Note:

1. Layout children contain both a `Layout` object for the child, and a `CGPoint` position. This position is the same thing as the `origin` in a view's frame.
2. In this example we actually pass a `NaN` value to our children to tell them that they can take as much space as they want in the direction that we want to allow scrolling.
