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
    
    // 캐시 NSCache = 담아두었다가 메모리가 부족하면 알아서 날림
    private let cash = NSCache<NSString, UIImage>()
    
    // 다운로드 이미지를 활용해서 UI 그리기 - view에 이미지를 세팅하는 함수 만들기
    func setImage(view: UIImageView, urlString: String) -> URLSessionDataTask? {
        
        if let image = cash.object(forKey: urlString as NSString) {
            view.image = image
            return nil
        }
        //이미지 다운로드
        return self.downloadImage(urlString: urlString) { [weak self]
            result in
            guard let self = self else { return }
            // 다운로드 성공시 메인큐에서 가져오기 (먼저 메인큐로 보내고 성공시 뷰에 이미지 넣기)
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    return
                case .success(let image):
                    
                    self.cash.setObject(image, forKey: urlString as NSString)
                    UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve) {
                        
                        view.image = image
                    } completion: { _ in
                        
                    }
                }
            }
        }
    }
    
    
    // 다운로드 하는 기능 작성
    func downloadImage(urlString: String, completion: @escaping
    (Result<UIImage, Error>) -> Void) -> URLSessionDataTask {
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
        
        // cancel : 요청 중단 함수
        return task
        }
}
