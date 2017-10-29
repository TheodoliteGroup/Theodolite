---
docid: best-practices
title: Best Practices
layout: docs
permalink: /docs/best-practices
---

## Keep components < 200 lines

In ComponentKit, the rule is 300 lines. Swift is a more expressive and less verbose language, plus Theodolite requires far less boilerplate than CKComponents require.

If your component is starting to extend beyond 200 lines, try to split it up into separate responsibilities, and compose them to build the same functionality.

## No singletons

Pass data to components explicitly. Due to the multithreaded nature of Theodolite, you're like to end up with difficult-to-debug issues if you heavily use singletons.

## Immutable data

Always use immutable data with Theodolite. Due to the multithreaded lifecycle, you'll end up with fewer issues. Check out [Apollo for iOS](http://dev.apollodata.com/ios/) for a fully-featured immutable GraphQL query and model infrastructure.
