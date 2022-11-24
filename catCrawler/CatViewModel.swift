//
//  CatViewModel.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/23.
//
// 3:00
import Foundation
import SwiftUI

// 리스펀스 가져오는 것이 비동기라서 값을 언제 가져오는지 알기 힘들기 때문에 load하고 나서 알수 있도록 하는 output 생성 -> delgate가 물어주게 작동
protocol CatViewModelOutPut: AnyObject {
    func loadComplete()
}


final class CatViewModel {
    
    // 현재 페이지 값
    private var currentPage = 0
    
    // 한번에 가져오는 사진의 개수 (21장)
    private var limit = 3 * 7
    
    private let service = CatService()
    
    //데이터를 담아올 공간
    var data: [CatResponse] = []
    
    weak var delegate: CatViewModelOutPut?
    
    var isloading: Bool = false
    
    // 무한 로딩
    func loadMoreIfNeed(index: Int) {
        if index > data.count - 10 {
            self.load()
        }
    }
    
    // 불러오는 함수
    func load() {
        guard !isloading else { return } // isloading이면 아무것도 하지 않음
        self.isloading = true
        self.service.getCats(page: self.currentPage, limit: self.limit) {
            result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    break
                case .success(let response):
                    self.data.append(contentsOf: response)
                    self.currentPage += 1
                    self.delegate?.loadComplete()
                }
                self.isloading = false
            }
            
        }
    }
}
