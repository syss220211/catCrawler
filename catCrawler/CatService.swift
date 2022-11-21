//
//  CatService.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/22.
//

import Foundation

final class CatService {
    
    enum RequestError: Error {
        case networkError
    }
    
    // 페이지와 리미트 값을 받는 함수
    func getCats(
        page: Int,
        limit: Int,
        completion: @escaping (Result<String, RequestError>) -> Void
        // Result : 성공 실패 여부를 담을 수 있는 스위프트 변수
    ) {
        var components = URLComponents(string: "http://api.thecatapi.com/v1/images/search")!
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard error != nil else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            guard let response = String(data: data, encoding: .unicode)
            else {
                completion(.failure(.networkError))
                return
            }
            print(response)
            
            completion(.success(response))
    
        }
    }
}
