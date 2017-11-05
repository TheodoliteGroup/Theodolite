---
docid: recycling
title: Recycling
layout: docs
permalink: /docs/recycling
---

# Automatic recycling #

Theoodlite is built around the concept of infrastructural reuse of views in scrolling lists. The framework provides a general-purpose algorithm to transform any Theodolite-generated view hierarchy into a hierarchy for reuse by another Component.

This view reuse algorithm is a little mysterious, and you should pretty much never have to directly interact with it. This reference is for those who want to dig deeper, but it's not necessary to understand this deeply.

## View configurations ##

You’ve probably seen Theodolite view configurations before, they look like this in most call sites:

```swift
final class FooComponent: Component, TypedComponent {
  typealias PropType = String

  override func view() -> ViewConfiguration? {
    return ViewConfiguration(
      UIView.self,
      attributes:
        ViewOptions(backgroundColor: UIColor.red).viewAttributes()
    )
  }
}
 ```

A view configuration is defined by these values:

* View class: The CKComponent declares what type of view it wants to be rendered in. The view is optional for any component, which allows us to have deep component hierarchies, and relatively flat views.
* Attributes: An array of view attributes. `ViewOptions` is a handy helper that generates this list of view attributes for you.

By using a declarative mapping of attributes, Theodolite gets to intelligently apply those attributes in an optimal manner on views.

## View attributes ##

A view attribute applies a single value to a view. Think `backgroundColor`, or `userInteractionEnabled`.

* applicator: A closure that takes the view, and the attribute value as arguments, and applies the attribute to the view.
* identifier: a std::string that should be used to identify this attribute. This should be unique to the attribute, since it’s used to decide which blocks to call on a view, and if there are collisions, the behavior is undefined (but is almost certainly incorrect).

## Attribute application ##

We’ve covered view configurations, which are constructed of a view class, and a map of attributes. One of the crucial elements of view reuse is the application of these attributes on a view that was previously used by a different CKComponent. You can check out this algorithm here.

I think this is important to understand before we get into the reuse algorithm. Here’s an outline of how it works:

### 1. ViewConfigurations are attached to all Theodolite-managed views ###

Whenever we configure a UIView, we use an associated object to attach the view configuration we’ve applied to this view. This configuration can be used to determine what the current attributes and values are that have been applied to the view previously, and which ones we have to change.

These configurations are our only knowledge of the attributes applied to the view, so if you change something about a view inside of mount, we have no way of knowing you changed something. That means you have to be sure to clean up any changes you applied manually, since the framework will not do it for you.

### 2. ViewConfigurations are applied only when they change ###

Because we have these configurations attached to every view, we know what we've applied in the past. We equate the configurations, and when they are not equal, we re-apply.

### 3. If applying to a view that already had a view configuration, unapplication is called before application ###

Some attributes (like gesture recognizers, etc.) have to be careful about un-setting values before applying. This is commony for attributes that *add* instead of *setting* a value. Therefore, `unapply` is called on the attribute before applying the new configuration, which gives the attribute an opportunity to remove the value.

However, most applicators do not provide unapplicators. Instead, they simply apply the new value without removing the old.

## Attribute shapes

This is the part that seems magical to most engineers when they really think about how reuse works in Theodolite and ComponentKit. Now that we understand attribute application, we can understand the fundamental problem with reuse:

What if I took the view associated with this component:

```swift
override func view() -> ViewConfiguration? {
  return ViewConfiguration(
    UIView.self,
    attributes:
      ViewOptions(
        backgroundColor: UIColor.red
      ).viewAttributes
  )
}
```

Then, I tried to reuse it for this component:

```swift
override func view() -> ViewConfiguration? {
  return ViewConfiguration(
    UIView.self,
    attributes:
      ViewOptions(
        alpha: 0.5
      ).viewAttributes
  )
}
```

As previously mentioned, normal attributes do not clean up their values on un-application. So using the algorithm we defined above, we could end up with a red background color in the reused view, which is quite unexpected.

Now, there are a few naive ways we could solve this:

1. We could provide an unapplicator for selector attributes.
2. You could manually set every value that you care about to avoid reuse problems.

Neither of these solutions sound great. The first option is non-optimal, since maybe a sibling component wants a view with a red background, and we’ve just lost the opportunity to do the minimal amount of work. The second option is awful, and would result in components that have enormous lists of attributes. This would be a terrible developer experience, and would be quite slow.

So what do we do? Well the answer is, use attribute shapes. It’s a fancy name for a simple concept: We build a representation of every attribute that was used to configure the view. We use this attribute shape to limit the views that a component is able to reuse.

In practice, attribute shapes are simply a container for a ViewConfiguration that changes the equality operator to use identity instead of full equality. It’s worth noting that attribute shapes don’t care what the attribute value is, just the attribute itself.

The use of attribute shapes lets us intelligently direct reuse of views with views they share the most in common. We can preferentially (and actually, exclusively) select views for reuse that would require only a reset of a few of their values.

## Reuse pools ##

The key revelation that lies at the heart of the Theodolite reuse algorithm is that hidden views in the hierarchy are actually very cheap. They don’t consume much memory (since their backing layers release their bitmap contents if they had any), and don’t incur many other costs for any other aspect of performance we care about much.

Reuse pools are therefore associated with each Theodolite-managed view in the hierarchy. They are localized to that specific view, and they don’t share views (unless they’re stateful views, covered in a previous note).

Now you might imagine that the reuse pools have a heinously complex algorithm for selecting views, but actually it’s quite simple, because the complexity is encapsulated in the hierarchical nature of the pools themselves. Here’s the taxonomy of reuse pools.

1. At the top, we have the parent UIView that is managed by Theodolite. It may have been created by this very reuse algorithm, or it may be a root component view.
2. Each reuse pool within this view is further divided by Component class. So if you have a FooComponent and BarComponent, they will never share views.
3. The next level is view class. If my FooClass generates both UIViews and UILabels through its view classes, we want to make sure we don’t mix them up in the same reuse pool.
4. The final level is the persistent attribute shape. For each shape, we have a different pool.

I find that this hierarchical view of the reuse pools is helpful, but in practice, all of these parameters are baked into a single ViewKey class, and the reuse pools are managed in a flat map from this key to the associated reuse pool. This map is stored in an Objective-C wrapper object, and is stored on the view using an associated object.

So in summary: Each view in the hierarchy has its own reuse pool of hidden, waiting views that are divided by their classes and attribute shapes. When we go to select a view for reuse, we compute the key for the view we’re looking for, find the associated reuse pool, and simply grab the top object in this reuse pool, unhiding it in the process.
