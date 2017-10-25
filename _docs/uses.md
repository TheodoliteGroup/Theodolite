---
docid: uses
title: Uses
layout: docs
permalink: /docs/uses
---

## List Views

Theodolite's primary use case is integrating with **UICollectionView** for complex content. Theodolite hierarchies will provide extremely smooth-scrolling collection views, even with extremely deep hierarchies and many different content types.

Just to re-iterate, Theodolite is built for performance in the scrolling list-view world. You get simpler view hierarchies, automatic reuse of views, and multithreaded layout. All of this together results in a better development and user experience.

## Declarative Views

Similar to React Components, Theodolite Components are much easier to maintain and reason about than traditional imperative view models. By describing **what** we want to display, and allow the framework to handle the rendering, you get a better architecture with no performance hit.

## Difficulties

Very dynamic UIs with animations and gestures are currently hard to implement in Theodolite. However, an animation API based on Litho's is in the works, and should allow very complex animations to be described.
