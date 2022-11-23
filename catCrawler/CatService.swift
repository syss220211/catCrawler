//
//  CatService.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/22.
//

import Foundation

struct CatResponse: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}


final class CatService {
    
    enum RequestError: Error {
        case networkError
    }
    
    // 페이지와 리미트 값을 받는 함수
    func getCats(
        page: Int,
        limit: Int,
        completion: @escaping (Result<CatResponse, RequestError>) -> Void
        // Result : 성공 실패 여부를 담을 수 있는 스위프트 변수
    ) {
        var components = URLComponents(string: "http://api.thecatapi.com/v1/images/search")!
        
        
        /*
         querryItems : 쿼리 문자열에 나타나는 순서대로 IRL에 대한 쿼리 항목의 배열
         각각은 키/쌍으로 이루어져 있다.
         URLComponents에 빈 쿼리 구성 요소가 있으면 빈배열, 쿼리 구성 요소가 없으면 URLComponentsnil 반환
         */
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        /* URLSession은 데이터를 다운로드/업로드하기 위한 API를 제공하는 클래스와 연관되어 있다. */
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                completion(.failure(.networkError)) // 에러 발생시 에러 리턴
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            guard let response = try?
                JSONDecoder().decode([CatResponse].self, from: data) else {
                completion(.failure(.networkError))
                return
            }
            print("response", response)
        }
        task.resume()
    }
}
