//
//  LayoutIntersection.swift
//  Theodolite
//
//  Created by Oliver Rickard on 2/18/18.
//  Copyright © 2018 Oliver Rickard. All rights reserved.
//

import Foundation

/**
 In order to make the mount algorithm fast with many children, we pre-compute intersections of existing rects.

 If a layout object has more than a set number of children, then the process of finding intersections can take a long
 time. So we pre-divide the layout's contiguous area into segments, as shown below:

      +-----------------+ <- Area of layout
      |                 |
 S1   | +-----+         |    C1-C4: children of the layout
      | |  C1 |  +---+  |    S1-S4: pre-computed segments
      | |     |  | C2|  |
      +-----------------+
      | |     |  |   |  |
 S2   | |     |  |   |  |
      | +-----+  |   |  |
      |          |   |  |
      +-----------------+ +
      |          |   |  | |
 S3   |          |   |  | | <- Stride
      |  +----+  +---+  | |
      |  | C3 |         | |
      +-----------------+ +
      |  |    |         |
 S4   |  |    |   +---+ |
      |  |    |   | C4| |
      |  +----+   +---+ |
      +-----------------+

 In this diagram, there are 4 children (C1-C4). We spatially partition this space into equally-sized rectangular
 segments (S1-S4). Because the stride is a constant number, we can find the intersecting segments in O(1) time, and
 only inspect the contents of those segments.

 This optimization means that we must do an O(N) computation up front (where N is the number of children in the layout),
 and then maintain an O(N) storage over time so that lookups can be constant-time. Due to the additional weight of this
 process, these intersection caches should only be maintained for layouts with 10+ elements.
 */

class IntersectionCache {
  let stride: CGFloat
  let segments: [[LayoutChild]]
  let vertical: Bool

  init(layout: Layout) {
    assert(layout.size.width >= 0, "Intersection caches don't work with negative dimensions")
    assert(layout.size.height >= 0, "Intersection caches don't work with negative dimensions")

    // First, we compute the bounds of the space we're working within:
    let size = layout.size

    // Now, we determine if the segmentation should be along the horizontal or vertical axis. If the vertical size is
    // larger than the horizontal, we assume this is a vertical layout, and segment along that axis.
    vertical = size.height > size.width

    // Compute the number of segments we will have. In the future we could nest these tables, but for now, we just keep
    // one layer of depth to the spatial hash table, and cap the number of buckets at 100. Up until that point, we try
    // to have about 10 children per segment. And we must always have at least 1 segment.
    let numberOfSegments = max(min(100, layout.children.count / 10), 1)

    // The stride is computed, note we're using ceil here to guarantee that we have strictly more elements
    stride = vertical ? ceil(size.height / CGFloat(numberOfSegments)) : ceil(size.width / CGFloat(numberOfSegments))

    var segments: [[LayoutChild]] = []

    // If the stride is zero, then we should just have a single segment with all children. This makes the algorithm
    // fully linear for all children, which is slower, but ther's not much else we can do without destroying init perf
    if stride == 0 {
      segments.append(layout.children)
    } else {
      for i in 0 ..< numberOfSegments {
        // We enumerate over the segments, incrementing
        let rect = CGRect(x: vertical ? 0 : stride * CGFloat(i),
                          y: vertical ? stride * CGFloat(i) : 0,
                          width: vertical ? layout.size.width : stride,
                          height: vertical ? stride : layout.size.height)

        var currentSegment: [LayoutChild] = []

        for layoutChild in layout.children {
          let childFrame = CGRect(origin: layoutChild.position,
                                  size: layoutChild.layout.size)
          if childFrame.intersects(rect) {
            currentSegment.append(layoutChild)
          }
        }

        segments.append(currentSegment)
      }
    }

    self.segments = segments
  }

  /**
   Computing the intersecting children involves first locating which segments to inspect, then searching those segments
   for intersecting children.

   Let's look at the example from above:

    +-----------------+
    |                 |
    | +-----+         |
    | |     |  +---+  |
    | |     |  |   |  |
    +-----------------+
    | |     |  |   |  |
    | |     |  |   |  |
    | +-----+  |   |  |
    |          |   |  |
    +-----------------+
    |    +-------+ |  |
    |    |     | | |  |
    |  +-|--+  +-|-+  |
    |  | |  |    |<------- provided rect
    +----|-------|----+
    |  | +-------+    |
    |  |    |   +---+ |
    |  |    |   |   | |
    |  +----+   +---+ |
    +-----------------+

   In this case the rect provided to the function begins in segment 3, and extends to segment 4. We can immediately
   jump to segment 3 without testing 1 or 2 since we know the stride of the spatially-partitioned table. In this example
   this saves us from comparing to rect 1 entirely, however imagine how this works for very large lists. This means we
   can immediately jump to the children deep in the list that intersect a given rect without testing all of their
   siblings that aren't close by. That makes intersection lookups constant-time.
  */
  func intersectingChildren(rect: CGRect) -> [LayoutChild] {
    var intersecting: [LayoutChild] = []

    assert(segments.count > 0, "Must have at least one segment")
    let lastIndex = segments.count - 1

    // First, we caculate which segment to begin and end at
    let beginningSegment =
      stride == 0 ? 0 : max(min(vertical ? Int(floor(rect.minY / stride)) : Int(floor(rect.minX / stride)), lastIndex), 0)
    let endingSegment =
      stride == 0 ? 0 : max(min(vertical ? Int(ceil(rect.maxY / stride)) : Int(ceil(rect.maxX / stride)), lastIndex), 0)

    for segment in segments[beginningSegment ... endingSegment] {
      for layoutChild in segment {
        let childFrame = CGRect(origin: layoutChild.position,
                                size: layoutChild.layout.size)
        if (childFrame.intersects(rect)) {
          intersecting.append(layoutChild)
        }
      }
    }

    return intersecting
  }
}
