//
//  SortByMonthView.swift
//  WorkoutDone
//
//  Created by hyemi on 2023/03/28.
//

import UIKit
import SnapKit
import Then

struct MonthInfo {
    var month : Int
    var monthImage : [String]
}

class SortByMonthView : BaseUIView {
    var monthSampleData : [MonthInfo] = [MonthInfo(month: 3, monthImage: Array(repeating: "", count: 9)), MonthInfo(month: 2, monthImage: Array(repeating: "", count: 12))]
    
    private let monthCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: "monthCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .orange
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegateDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.addSubview(monthCollectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        monthCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(((116 * 4) + (6 * 3) + 29 + 34) * 2)
        }
    }
    
    func setDelegateDataSource() {
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
    }
}

extension SortByMonthView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthSampleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30 , height: (116 * 4) + (6 * 3) + 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
}
