//
//  CatCell.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/22.
//

import Foundation
import UIKit

final class CatCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    // 다운로드 된 이미지 셀에서 가져다 쓰기
    private let service = ImageService.shared
    
    private var task: URLSessionDataTask?
    
    // 생성자 상속 후 override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // View setup 함수
    private func setupView() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    
        self.imageView.contentMode = .scaleToFill // 이미지 꽉차게
        self.imageView.clipsToBounds = true
        
    }
    func setupData(urlString: String) {
        
        task?.cancel()
        self.imageView.image = nil
        
        // 셀이미지로 이미지 뷰를 가져오기
        service.setImage(view: self.imageView, urlString: urlString)
        // 뷰를 재활용할때 데이터를 계속 다운받음 -> 전 데이터를  계속 덮어씌우는 형식이기 때문에 딜레이 발생 -> setUp전에 cell이 이미지를 다운받고 있으면 취소하는 작업 추가
    }
    
    
}
