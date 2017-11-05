---
docid: view-flattening
title: View Flattening
layout: docs
permalink: /docs/view-flattening
---

## Component != View

Components are not subclasses of UIViews. They're created and laid out off the main thread. This means that you can have very deep component hierarchies to control layout in a hierarchicial manner without incurring the costs of a deep view hierarchy.

This is best illustrated:

![A flatter hierarchy](http://theodolite.org/static/images/flatter-feed-hierarchy.png)

In traditional UIViews, you would either have to create a fairly confusing set of autolayout constraints to achieve this layout, or you'd have several levels of subviews. With Theodolite, this hierarchy is limited to only the views that are absolutely necessary.

Component hierarchies separate layout from display, which makes extraneous views unnecessary.
