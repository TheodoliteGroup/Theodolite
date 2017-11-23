//
//  NewsNetworkSource.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

func NewsItemFromJSON(json: [String: Any]) -> NewsItem {
  return NewsItem(
    title: json["title"] as! String,
    description: json["description"] as? String,
    url: URL(string: json["url"] as! String)!,
    timestamp: {
      if let publishedAt = json["publishedAt"] as? String {
        return ISO8601DateFormatter().date(from: publishedAt)
      }
      return nil
  }(),
    author: NewsItemAuthor(name: json["author"] as? String),
    media:{
      if let urlToImageString = json["urlToImage"] as? String {
        if let urlToImage = URL(string: urlToImageString) {
          return NewsItemMedia(imageURL: urlToImage)
        }
      }
      return NewsItemMedia(imageURL: nil)
  }())
}

class NewsNetworkSource: NetworkSource {
  typealias ItemType = NewsItem

  let url: URL

  init(url: URL) {
    self.url = url
  }

  func fetchItems(_ received: @escaping (NetworkSourceResult<NewsItem>) -> ()) {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    let request = URLRequest(url: url)

    let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
      let errorBlock = {
        DispatchQueue.main.async {
          received(NetworkSourceResult.error(string: "Couldn't parse JSON"))
        }
      }
      if let data = data {
        do {
          if let deserialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            guard let articlesJSON = deserialized["articles"] as? [[String: Any]] else {
              errorBlock()
              return
            }
            let articles = articlesJSON.map({ NewsItemFromJSON(json: $0) })
            DispatchQueue.main.async {
              received(NetworkSourceResult.success(articles))
            }
          } else {
            errorBlock()
          }
        } catch {
          errorBlock()
        }
      }
    }
    task.resume()
  }
}
