---
docid: getting-started
title: Getting Started
layout: docs-getting-started
permalink: /docs/getting-started
---

{% capture cocoapods %}{% include_relative getting-started/cocoapods.md %}{% endcapture %}
{% capture carthage %}{% include_relative getting-started/carthage.md %}{% endcapture %}

{{cocoapods | markdownify }}
{{carthage | markdownify }}
