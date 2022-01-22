//
//  File.swift
//  
//
//  Created by Павел Лунев on 18.01.2022.
//

import Foundation

public struct Articles: Codable {
    public let status: String
    public let totalResults: Int
    public let articles: [Article]
}

public struct Article: Codable {
    public let source: Source?
    public let author, title, articleDescription: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt, content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

public struct Source: Codable {
    public let id, name: String?
}

extension Article: Identifiable {
    public var id: String { url ?? "" }
}
