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
        self.imageView.backgroundColor = .cyan
        self.imageView.contentMode = .scaleToFill // 이미지 꽉차게
        
    }
    
    
}
