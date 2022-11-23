//
//  ViewController.swift
//  catCrawler
//
//  Created by 박서연 on 2022/11/18.
//

import UIKit

class ViewController: UIViewController, CatViewModelOutPut {
        

    // cell width지정에서 사용되는 간격은 여기서 따로 지정
    private enum Metrics {
        static let inset: CGFloat = 4 // Inset = 여백
        
    }
    
    /* UICollectionView : 데이터 아이템의 정렬된 컬렉션을 관리하고 사용자 지정 가능한 레이아웃을 사용하여 표시하는 개체
     UICollectionViewFlowLayout : 그리드 안에서 각 조직적 아이템의 각 섹션을 위한 헤더와 푸터 뷰의 레이아웃 객체
     => collectionVeiw에 대한 레이아웃 정보를 생성하기 위한 추상적인 기본 클래스
     * 오토레이아웃: 기기의 화면 크기가 변해도 사용자 입자에서 뷰의 비율이 동일하게끔 보이도록 배치하는 것 (순서 = translateAut... false, addSubView 추가, constraints 추가 */
    // 오토 레이아웃 설정
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
                    cv.backgroundColor = .white
        
        // 레이아웃에서 간격 지정
        layout.minimumLineSpacing = Metrics.inset
        layout.minimumInteritemSpacing = Metrics.inset
        
        return cv
    }()
    
    // CatViewModel 넣기
    private let viewModel = CatViewModel()
    
    
    /*viewDidLoad : 뷰의 컨트롤로가 메모리에 로드되는 난 후 호출되는 뷰, 뷰의 로딩이 완료 되었을 때,
     시스템에 의해 자동으로 호출되며, 화면이 처음 만들어질때 한번만 실행됨 */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.view.addSubview(self.collectionView) // addSubView : view위에 sub(하위) view를 추가하겠다 = 새로운 하위 뷰를 얹어넣겠다
        
        
        // translatesAutoresizingMaskIntoConstraints : View의 autoresizing  mask가  Auto Layout constraints으로 변환(translated)되는지 여부를 결정하는 Bool값
        // autoresizing mask? : UIView의 인스턴스 프로퍼티, Super View의 bounds가 변경 될 때, recevier의 size를 조정하는 방법을 결정하는 UIViewAutoresizing의 구조체 인스턴스
        // 기종에 따라서 자동으로 size를 조정하지만(auto layout), constraint를 지정할 수 있게 하기 위해서 false를 사용
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // NSLayoutConstraint : 제약 기반의 레이아웃 시스템에서 충족해야하는 두 인터페이스 개체간의 관계
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.collectionView.backgroundColor = .white
        // collectionView에서 커스텀 셀을 사용하기 위해서 UITableView.register 함수를 통해 미리 셀을 등록
        self.collectionView.register(CatCell.self, forCellWithReuseIdentifier: "Cell")
        // forCellWithReuseIdentifier : 재사용할 셀 지정 "Cell"
        // UICollectionView를 상속하는 새로운 셀 생성 UICollectionViewCell -> CatCell
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.viewModel.delegate = self
        self.viewModel.load()
     }
    
    func loadComplete() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatCell // CatCell이라는 cell 사용을 명시
        let data = self.viewModel.data[indexPath.item]
        cell.setupData(urlString: data.url)
        return cell
    }
    
    
    
}

