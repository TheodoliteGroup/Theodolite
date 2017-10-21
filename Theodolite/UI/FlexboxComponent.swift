//
//  FlexboxComponent.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/21/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Flexbox

public struct FlexOptions {
  let size: CGSize
  let minSize: CGSize
  let maxSize: CGSize
  
  let flexDirection: Style.FlexDirection
  let flexWrap: Style.FlexWrap
  let justifyContent: Style.JustifyContent
  let alignItems: Style.AlignItems
  let alignContent: Style.AlignContent
  
  let direction: Style.Direction
  let overflow: Style.Overflow
  
  public init(
    size: CGSize = CGSize(width: CGFloat.nan, height: .nan),
    minSize: CGSize = CGSize(width: CGFloat.nan, height: .nan),
    maxSize: CGSize = CGSize(width: CGFloat.nan, height: .nan),
    
    flexDirection: Style.FlexDirection = .row,
    flexWrap: Style.FlexWrap = .nowrap,
    justifyContent: Style.JustifyContent = .flexStart,
    alignItems: Style.AlignItems = .stretch,
    alignContent: Style.AlignContent = .stretch,
    
    direction: Style.Direction = .inherit,
    overflow: Style.Overflow = .visible
    )
  {
    self.size = size
    self.minSize = minSize
    self.maxSize = maxSize
    
    self.flexDirection = flexDirection
    self.flexWrap = flexWrap
    self.justifyContent = justifyContent
    self.alignItems = alignItems
    self.alignContent = alignContent
    
    self.direction = direction
    self.overflow = overflow
  }
}

public struct FlexChild {
  let component: Component?
  let alignSelf: Style.AlignSelf
  
  let flex: CGFloat
  let flexGrow: CGFloat
  let flexShrink: CGFloat
  let flexBasis: CGFloat
  
  let positionType: Style.PositionType
  
  let position: Edges
  let margin: Edges
  let padding: Edges
  let border: Edges
  
  public init(_ component: Component?,
              
              alignSelf: Style.AlignSelf = .auto,
              
              flex: CGFloat = .nan,       // CSS default = 0
              flexGrow: CGFloat = .nan,   // CSS default = 0
              flexShrink: CGFloat = .nan, // CSS default = 1
              flexBasis: CGFloat = .nan,  // CSS default = .auto
    
              positionType: Style.PositionType = .relative,
    
              position: Edges = Edges(uniform: .nan),
              margin: Edges = Edges(uniform: .nan),
              padding: Edges = Edges(uniform: .nan),
              border: Edges = Edges(uniform: .nan)
    ) {
    self.component = component
    
    self.alignSelf = alignSelf
    
    self.flex = flex
    self.flexGrow = flexGrow
    self.flexShrink = flexShrink
    self.flexBasis = flexBasis
    
    self.position = position
    self.margin = margin
    self.padding = padding
    self.border = border
    
    self.positionType = positionType
  }
}

final public class FlexboxComponent: TypedComponent {
  public typealias PropType = (
    options: FlexOptions,
    children: [FlexChild]
  )
  
  public init() {}
  
  public func render() -> [Component?] {
    return self.props().children.map({
      (child: FlexChild) -> Component? in child.component
    }).filter({ $0 != nil }).map({$0!})
  }
  
  public func layout(constraint: CGSize, tree: ComponentTree) -> Layout {
    let props = self.props()
    
    var childLayoutNodes: [Node] = []
    // Yoga doesn't let us pass data from the measure function out, but we need to get the layout objects that each
    // child component built. So we use this map table to keep track of the layouts that each component generated
    let layoutTable = NSMapTable<AnyObject, Layout>(keyOptions: [.strongMemory, .objectPointerPersonality],
                                                    valueOptions: .strongMemory)
    
    // First, we prepare the child layout nodes with measure functions and input parameters so that Yoga knows what to
    // do with each child.
    for (index, childTree) in tree.children().enumerated() {
      // Get the flexchild at the same index
      let flexChild = props.children[index]
      let component = childTree?.component()
      childLayoutNodes
        .append(Node(
          alignSelf: flexChild.alignSelf,
          flex: flexChild.flex,
          flexGrow: flexChild.flexGrow,
          flexShrink: flexChild.flexShrink,
          flexBasis: flexChild.flexBasis,
          positionType: flexChild.positionType,
          position: flexChild.position,
          margin: flexChild.margin,
          padding: flexChild.padding,
          border: flexChild.border) { (constraint: CGSize) -> CGSize in
            guard let c = component else {
              return CGSize(width: 0, height: 0)
            }
            let childLayout =
              c.layout(constraint: constraint, tree: childTree!)
            layoutTable.setObject(childLayout, forKey: c)
            return childLayout.size
      })
    }
    
    // Next, we build a node for ourselves
    let selfNode = Node.init(size: props.options.size,
                             minSize: props.options.minSize,
                             maxSize: props.options.maxSize,
                             children: childLayoutNodes,
                             flexDirection: props.options.flexDirection,
                             flexWrap: props.options.flexWrap,
                             justifyContent: props.options.justifyContent,
                             alignItems: props.options.alignItems,
                             alignContent: props.options.alignContent,
                             alignSelf: .auto,
                             direction: props.options.direction,
                             overflow: props.options.overflow)
    
    let nodeLayout = selfNode.layout(maxSize: constraint)
    
    // Layout should be complete now, but we need to unpack the result of the layout operation into a component layout
    
    var childLayouts: [LayoutChild] = []
    for (index, childTree) in tree.children().enumerated() {
      guard let component = childTree?.component() else {
        childLayouts.append(LayoutChild(
          layout: Layout(component: nil,
                         size: CGSize(width: 0, height: 0),
                         children: []),
          position: CGPoint(x: 0, y: 0)))
        continue
      }
      
      childLayouts.append(LayoutChild(layout: layoutTable.object(forKey: component)!,
                                      position: nodeLayout.children[index].frame.origin))
    }
    
    return Layout(component: self,
                  size: nodeLayout.frame.size, children: childLayouts)
  }
}
