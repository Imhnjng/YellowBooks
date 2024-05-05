//
//  BookManager.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/4/24.
//

import Foundation

enum SearchBookTarget: String {
    case title, isbn, publisher, person
}

class BookManager {
    static let shared = BookManager()
    private init() {}
    let url = "https://dapi.kakao.com/v3/search/book"
    let apiKey = "acd94dbb68d7d1b322b148d90e258d03"
    
    func fetchBookData(withQuery query: String, targets: [SearchBookTarget] = [], completion: @escaping (Bool, SearchBookResponse?) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else {
            print("Invalid URL")
            return
        }
        var queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "target", value: "title"),
            URLQueryItem(name: "query", value: query),
        ]
        // target 값 있을시 실행
        if !targets.isEmpty {
            let target = targets.compactMap { x in x.rawValue }.joined(separator: ",")
//            print("target: \(target)")
            queryItems.append(URLQueryItem(name: "target", value: target))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //에러처리
            if let error = error {
                print("Error \(error)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                print("Invalid response")
//                return
//            }
            
            // let text = String(data: data, encoding: .utf8)   // text로 변환해서 데이터 확인
            do {
                let response = try JSONDecoder().decode(SearchBookResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true, response)
                }
            } catch {
                //                        completion(.failure(error))
                print("json decode error \(error)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        
        task.resume()
    }
}
