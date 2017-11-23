// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - AutoModel AutoEquatable
internal func == (lhs: AutoModel, rhs: AutoModel) -> Bool {
    return true
}
// MARK: - NewsItem AutoEquatable
extension NewsItem: Equatable {}
internal func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard compareOptionals(lhs: lhs.description, rhs: rhs.description, compare: ==) else { return false }
    guard lhs.url == rhs.url else { return false }
    guard compareOptionals(lhs: lhs.timestamp, rhs: rhs.timestamp, compare: ==) else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.media == rhs.media else { return false }
    return true
}
// MARK: - NewsItemAuthor AutoEquatable
extension NewsItemAuthor: Equatable {}
internal func == (lhs: NewsItemAuthor, rhs: NewsItemAuthor) -> Bool {
    guard compareOptionals(lhs: lhs.name, rhs: rhs.name, compare: ==) else { return false }
    return true
}
// MARK: - NewsItemMedia AutoEquatable
extension NewsItemMedia: Equatable {}
internal func == (lhs: NewsItemMedia, rhs: NewsItemMedia) -> Bool {
    guard compareOptionals(lhs: lhs.imageURL, rhs: rhs.imageURL, compare: ==) else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// swiftlint:disable file_length
// swiftlint:disable line_length

fileprivate func combineHashes(_ hashes: [Int]) -> Int {
    return hashes.reduce(0, combineHashValues)
}

fileprivate func combineHashValues(_ initial: Int, _ other: Int) -> Int {
    #if arch(x86_64) || arch(arm64)
        let magic: UInt = 0x9e3779b97f4a7c15
    #elseif arch(i386) || arch(arm)
        let magic: UInt = 0x9e3779b9
    #endif
    var lhs = UInt(bitPattern: initial)
    let rhs = UInt(bitPattern: other)
    lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
    return Int(bitPattern: lhs)
}

fileprivate func hashArray<T: Hashable>(_ array: [T]?) -> Int {
    guard let array = array else {
        return 0
    }
    return array.reduce(5381) {
        ($0 << 5) &+ $0 &+ $1.hashValue
    }
}

fileprivate func hashDictionary<T, U: Hashable>(_ dictionary: [T: U]?) -> Int {
    guard let dictionary = dictionary else {
        return 0
    }
    return dictionary.reduce(5381) {
        combineHashValues($0, combineHashValues($1.key.hashValue, $1.value.hashValue))
    }
}




// MARK: - AutoHashable for classes, protocols, structs
// MARK: - AutoModel AutoHashable
extension AutoModel {
    internal var hashValue: Int {
        return combineHashes([
            0])
    }
}
// MARK: - NewsItem AutoHashable
extension NewsItem: Hashable {
    internal var hashValue: Int {
        return combineHashes([
            title.hashValue,
            description?.hashValue ?? 0,
            url.hashValue,
            timestamp?.hashValue ?? 0,
            author.hashValue,
            media.hashValue,
            0])
    }
}
// MARK: - NewsItemAuthor AutoHashable
extension NewsItemAuthor: Hashable {
    internal var hashValue: Int {
        return combineHashes([
            name?.hashValue ?? 0,
            0])
    }
}
// MARK: - NewsItemMedia AutoHashable
extension NewsItemMedia: Hashable {
    internal var hashValue: Int {
        return combineHashes([
            imageURL?.hashValue ?? 0,
            0])
    }
}

// MARK: - AutoHashable for Enums

import Foundation

// swiftlint:disable variable_name
infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole
}

func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        get: { a in rhs.get(lhs.get(a)) },
        set: { (c, a) in lhs.set(rhs.set(c, lhs.get(a)), a) }
    )
}

func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in lhs.set(rhs, a) }
}

func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

extension NewsItem {
  static let titleLens = Lens<NewsItem, String>(
    get: { $0.title },
    set: { title, newsitem in
       NewsItem(title: title, description: newsitem.description, url: newsitem.url, timestamp: newsitem.timestamp, author: newsitem.author, media: newsitem.media)
    }
  )
  static let descriptionLens = Lens<NewsItem, String?>(
    get: { $0.description },
    set: { description, newsitem in
       NewsItem(title: newsitem.title, description: description, url: newsitem.url, timestamp: newsitem.timestamp, author: newsitem.author, media: newsitem.media)
    }
  )
  static let urlLens = Lens<NewsItem, URL>(
    get: { $0.url },
    set: { url, newsitem in
       NewsItem(title: newsitem.title, description: newsitem.description, url: url, timestamp: newsitem.timestamp, author: newsitem.author, media: newsitem.media)
    }
  )
  static let timestampLens = Lens<NewsItem, Date?>(
    get: { $0.timestamp },
    set: { timestamp, newsitem in
       NewsItem(title: newsitem.title, description: newsitem.description, url: newsitem.url, timestamp: timestamp, author: newsitem.author, media: newsitem.media)
    }
  )
  static let authorLens = Lens<NewsItem, NewsItemAuthor>(
    get: { $0.author },
    set: { author, newsitem in
       NewsItem(title: newsitem.title, description: newsitem.description, url: newsitem.url, timestamp: newsitem.timestamp, author: author, media: newsitem.media)
    }
  )
  static let mediaLens = Lens<NewsItem, NewsItemMedia>(
    get: { $0.media },
    set: { media, newsitem in
       NewsItem(title: newsitem.title, description: newsitem.description, url: newsitem.url, timestamp: newsitem.timestamp, author: newsitem.author, media: media)
    }
  )
}
extension NewsItemAuthor {
  static let nameLens = Lens<NewsItemAuthor, String?>(
    get: { $0.name },
    set: { name, newsitemauthor in
       NewsItemAuthor(name: name)
    }
  )
}
extension NewsItemMedia {
  static let imageURLLens = Lens<NewsItemMedia, URL?>(
    get: { $0.imageURL },
    set: { imageURL, newsitemmedia in
       NewsItemMedia(imageURL: imageURL)
    }
  )
}
