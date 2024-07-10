//
//  APIManager.swift
//  EnRoute
//
//  Created by Anooj Krishnan G on 11/07/24.
//

import Foundation

class ApiManager {

  static func fetchData(from urlString: String, with body: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
      return
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    do {
      let bodyData = try convertDictionaryToPostData(body: body)
      urlRequest.httpBody = bodyData
    } catch {
      completion(.failure(error))
      return
    }

    let session = URLSession.shared
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard let data = data else {
        completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
        return
      }

      completion(.success(data))
    }

    dataTask.resume()
  }

  private static func convertDictionaryToPostData(body: [String: String]) throws -> Data {
    let urlEncodedBody = body.map { key, value in
      "\(key)=\(value)"
    }.joined(separator: "&")
    return Data(urlEncodedBody.utf8)
  }
}
