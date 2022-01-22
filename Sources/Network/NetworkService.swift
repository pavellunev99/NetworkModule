//
//  File.swift
//  
//
//  Created by Павел Лунев on 18.01.2022.
//

import Foundation

enum Method: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

public enum RequestError: Error {
    case urlParse
    case requestParse
    case someFail
}

public protocol NetworkInteractor: AnyObject {
    func everythingGet(q: String, sortBy: SortBy, language: String, page: Int?, completion: @escaping ((Result<Articles?, RequestError>) -> Void))
}

public final class NetworkService: NetworkInteractor {

    public init() {
    }

    private let session: URLSession = {
        $0
    }(URLSession(configuration: URLSessionConfiguration.ephemeral))

    private let requestQueue: OperationQueue = {
        $0.qualityOfService = .userInitiated
        $0.maxConcurrentOperationCount = .max
        return $0
    }(OperationQueue())

    func performRequest(with url: URL,
                        httpBody: Data?,
                        headers: [String: String],
                        method: Method, completion: @escaping((Result<Data?, RequestError>) -> Void)) {

        requestLog(method: method, url: url, data: httpBody)

        let request: URLRequest = configureRequest(url, httpBody, headers: headers, method: method)

        let operation: RequestOperation = .init(session: session, request: request) { (maybeData) in
            DispatchQueue.main.async {
                completion(.success(maybeData))
            }
        } errorBlock: { (errorCode) in
            DispatchQueue.main.async {
                completion(.failure(.someFail))
            }
        }

        requestQueue.addOperation(operation)
    }

    fileprivate func configureRequest(_ url: URL, _ data: Data?, headers: [String: String], method: Method) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }

    fileprivate func requestLog(method: Method, url: URL, data: Data?) {
        print("⬆️ Request:", "\n",
              "Method:", method.rawValue, "\n",
              "URL:", url, "\n",
              "Data:", String(data: data ?? Data(), encoding: .utf8) ?? "", "\n")
    }
}
