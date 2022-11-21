//
//  ViewController.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/18.
//

import UIKit

class ViewController: UIViewController {

    // cell width지정에서 사용되는 간격은 여기서 따로 지정
    private enum Metrics {
        static let inset: CGFloat = 4 // Inset = 여백
        
    }
    
    /* UICollectionView : 데이터 아이템의 정렬된 컬렉션을 관리하고 사용자 지정 가능한 레이아웃을 사용하여 표시하는 개체
     UICollectionViewFlowLayout : 그리드 안에서 각 조직적 아이템의 각 섹션을 위한 헤더와 푸터 뷰의 레이아웃 객체
     => collectionVeiw에 대한 레이아웃 정보를 생성하기 위한 추상적인 기본 클래스 */
    // 레이아웃 설정
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
                    cv.backgroundColor = .white
        
        // 레이아웃에서 간격 지정
        layout.minimumLineSpacing = Metrics.inset
        layout.minimumInteritemSpacing = Metrics.inset
        
        return cv
    }()
    
    /*viewDidLoad : 뷰의 컨트롤로가 메모리에 로드되는 난 후 호출되는 뷰, 뷰의 로딩이 완료 되었을 때,
     시스템에 의해 자동으로 호출되며, 화면이 처음 만들어질때 한번만 실행됨 */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.collectionView.backgroundColor = .red
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
     }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // cell의 사이즈 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        // 전체 가로 길이 = collectionView의 프레임의 width / 3, 사이사이 간격도 주기
        let width = collectionView.frame.width
        // 셀 3개 = 여백(inset) 2개
        let cellWidth = (width - 2 * Metrics.inset) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    
    
}

