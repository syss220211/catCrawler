//
//  ImageService.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/23.
//

// url 에서 이미지 다운받아서 불러오도록 만들어주기
import Foundation
import UIKit

class ImageService {
    
    // 어디서나 쓸 수 있도록 싱글톤으로 작성
    static let shared = ImageService()
    
    enum Network: Error {
        case networkError
    }
    
    // 다운로드 이미지를 활용해서 UI 그리기 - view에 이미지를 세팅하는 함수 만들기
    func setImage(view: UIImageView, urlString: String) {
        
        //이미지 다운로드
        self.downloadImage(urlString: urlString) { result in
            
            // 다운로드 성공시 메인큐에서 가져오기 (먼저 메인큐로 보내고 성공시 뷰에 이미지 넣기)
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    return
                case .success(let image):
                    view.image = image
                }
            }
            
        }
    }
    
    
    // 다운로드 하는 기능 작성
    func downloadImage(urlString: String, completion: @escaping
    (Result<UIImage, Error>) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, request, error in
            
            guard error == nil else {
                completion(.failure(Network.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(Network.networkError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(Network.networkError))
                return
            }
            completion(.success(image))
            
        }
        task.resume()
        }
}
