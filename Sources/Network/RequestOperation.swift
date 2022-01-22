//
//  RequestOperation.swift
//  
//
//  Created by Павел Лунев on 18.01.2022.
//

import Foundation

protocol RequestOperationCompletionBlock {
    associatedtype DataType
    var completionDataBlock: (DataType) -> Void { get set }
    var errorBlock: (_ statusCode: Int) -> Void { get set }
}

class RequestOperation: AsyncOperation, RequestOperationCompletionBlock {
    internal var completionDataBlock: (_ data: Data?) -> Void
    internal var errorBlock: (_ statusCode: Int) -> Void

    let session: URLSession
    let request: URLRequest

    init(session: URLSession, request: URLRequest, completitionHandler: @escaping (_ data: Data?) -> Void, errorBlock: @escaping (_ statusCode: Int) -> Void) {

        self.completionDataBlock = completitionHandler
        self.errorBlock = errorBlock
        self.session = session
        self.request = request
    }

    override func execute() {
        super.execute()

        session.dataTask(with: request) { [weak self] (maybeData, maybeResponse, _) in
            guard let response = maybeResponse as? HTTPURLResponse else {
                self?.error(errorCode: 0)
                return
            }
            if let url = maybeResponse?.url {
                self?.responseLog(response: response, data: maybeData, url: url)
            }
            DispatchQueue.main.async {
                switch response.statusCode {
                case 200...226:
                    self?.success(data: maybeData)
                default:
                    self?.error(errorCode: response.statusCode)
                }
            }
        }.resume()
    }

    func error(errorCode: Int) {
        errorBlock(errorCode)
        end()
    }

    func success(data: Data?) {
        completionDataBlock(data)
        end()
    }

    fileprivate func responseLog(response: HTTPURLResponse, data: Data?, url: URL) {
        print("⬇️ Response:", "\n",
              "Status code:", response.statusCode, "\n",
              "URL: ", "\(url)", "\n",
              "Data:", data == nil ? "null" : String(data: data!, encoding: .utf8) ?? "null", "\n")
    }
}
