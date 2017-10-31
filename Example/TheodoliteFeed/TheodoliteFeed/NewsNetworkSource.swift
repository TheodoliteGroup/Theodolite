//
//  NewsNetworkSource.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/30/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

struct NewsItem {
  let title: String
  let description: String?
  let url: URL
  let imageURL: URL?
  let timestamp: Date?
  let author: String?

  init(json: [String:Any]) {
    self.title = json["title"] as! String
    self.description = json["description"] as? String
    self.url = URL(string: json["url"] as! String)!
    self.imageURL = {
      if let urlToImage = json["urlToImage"] as? String {
        return URL(string: urlToImage)
      }
      return nil
    }()
    self.timestamp = {
      if let publishedAt = json["publishedAt"] as? String {
        return ISO8601DateFormatter().date(from: publishedAt)
      }
      return nil
    }()
    self.author = json["author"] as? String
  }
}

class NewsNetworkSource: NetworkSource {
  typealias ItemType = NewsItem

  private let url: URL

  init(url: URL) {
    self.url = url
  }

  func fetchItems(_ received: @escaping (NetworkSourceResult<NewsItem>) -> ()) {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    let request = URLRequest(url: url)

    let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
      if let data = data {
        do {
          if let deserialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            let articlesJSON = deserialized["articles"] as! [[String: Any]]
            let articles = articlesJSON.map({ NewsItem(json: $0) })
            DispatchQueue.main.async {
              received(NetworkSourceResult.success(articles))
            }
          } else {
            DispatchQueue.main.async {
              received(NetworkSourceResult.error(string: "Couldn't parse JSON"))
            }
          }
        } catch {
          DispatchQueue.main.async {
            received(NetworkSourceResult.error(string: "Couldn't parse JSON"))
          }
        }
      }
    }
    task.resume()
  }
}
