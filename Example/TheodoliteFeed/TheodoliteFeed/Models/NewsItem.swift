//
//  NewsItem.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/20/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

struct NewsItem: Hashable, Equatable {
  let title: String
  let description: String?
  let url: URL
  let timestamp: Date?
  let author: NewsItemAuthor
  let media: NewsItemMedia
}

struct NewsItemAuthor: Hashable, Equatable {
  let name: String?
}

struct NewsItemMedia: Hashable, Equatable {
  let imageURL: URL?
}
