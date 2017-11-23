//
//  NewsItem.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 11/20/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

struct NewsItem: AutoModel {
  let title: String
  let description: String?
  let url: URL
  let timestamp: Date?
  let author: NewsItemAuthor
  let media: NewsItemMedia
}

struct NewsItemAuthor: AutoModel {
  let name: String?
}

struct NewsItemMedia: AutoModel {
  let imageURL: URL?
}
