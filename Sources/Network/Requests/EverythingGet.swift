//
//  EverythingGet.swift
//  
//
//  Created by Павел Лунев on 18.01.2022.
//

import Foundation

public enum SortBy: String {
    case relevancy = "relevancy"
    case popularity = "popularity"
    case publishedAt = "publishedAt"
}

extension NetworkService {

    public func everythingGet(q: String, sortBy: SortBy, language: String, page: Int? = nil, completion: @escaping ((Result<Articles?, RequestError>) -> Void)) {

        let urlString = "\(Endpoint.url)everything?q=\(q)&language=\(language)&sortBy=\(sortBy.rawValue)\(page == nil ? "" : "&page=\(page!)")&apiKey=\(Environment.token)"

        guard let url = URL(string: urlString) else { completion(.failure(.urlParse)); return }

        performRequest(with: url, httpBody: nil, headers: [:], method: .get) { (statusData) in
            switch statusData {
            case .success(let maybeData):
                if let data = maybeData, let articles = try? JSONDecoder().decode(Articles.self, from: data) {
                    completion(.success(articles))
                } else {
                    completion(.failure(.requestParse))
                }
            case .failure:
                completion(.failure(.someFail))
            }
        }
    }
}
