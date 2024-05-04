//
//  BookManager.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/4/24.
//

import Foundation

class BookManager {
    static let shared = BookManager()
    private init() {}
    let url = "https://dapi.kakao.com/v3/search/book"
    let apiKey = "acd94dbb68d7d1b322b148d90e258d03"
    
    func fetchBookData() {
        func fetchBookData(withQuery query: String, completion: @escaping ([Document]) -> Void) {
            
            guard var urlComponents = URLComponents(string: url) else {
                print("Invalid URL")
                return
            }
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "query", value: query),
            ]
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }
            
           
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Welcome.self, from: data)
                        print(decodedData.documents)
                        completion(decodedData.documents)
                    } catch {
//                        completion(.failure(error))
                        print("Error \(error)")
                    }
                }
            }
            
            task.resume()
        }
    }
    
}
