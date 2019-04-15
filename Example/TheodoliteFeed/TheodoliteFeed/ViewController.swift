//
//  ViewController.swift
//  TheodoliteFeed
//
//  Created by Oliver Rickard on 10/28/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

import Theodolite

class ViewController: UIViewController {
  private let navigationCoordinator: NavigationCoordinator

  init(navigationCoordinator: NavigationCoordinator) {
    self.navigationCoordinator = navigationCoordinator
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }

  override func loadView() {
    let hostingView = ComponentHostingView { () -> Component in
      return ScrollComponent(
        (NewsAggregationComponent(
          ([
            NewsOutlet(
              name: "Tech Crunch",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=techcrunch&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "Ars Technica",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=ars-technica&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=ars-technica&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "BBC News",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=bbc-news&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "Business Insider",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=business-insider&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=business-insider&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "Buzzfeed",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=buzzfeed&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=buzzfeed&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "CNN",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=cnn&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=cnn&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!),
            NewsOutlet(
              name: "Hacker News",
              topNewsURL: URL(string: "https://newsapi.org/v1/articles?source=hacker-news&sortBy=top&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!,
              latestNewsURL: URL(string: "https://newsapi.org/v1/articles?source=hacker-news&sortBy=latest&apiKey=8a3eb75ec47c4054aed11906b84b6b3e")!)
            ],
           navigationCoordinator: self.navigationCoordinator)
          ),
         direction: .horizontal,
         attributes: [
          Attr(true, identifier: "theodolite-pagingEnabled")
          { (view: UIScrollView, value: Bool) -> () in
            view.isPagingEnabled = value
          }])
      )
    }
    hostingView.backgroundColor = .white
    
    self.view = hostingView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "News"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

