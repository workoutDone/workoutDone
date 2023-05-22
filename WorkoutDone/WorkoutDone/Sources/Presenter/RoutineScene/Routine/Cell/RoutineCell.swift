//
//  RoutineCell.swift
//  WorkoutDone
//
//  Created by hyemi on 2023/05/15.
//

import UIKit
import SnapKit
import Then

class RoutineCell : UITableViewCell {
    var seletedIndex = -1
    
    let outerView = UIView().then {
        $0.backgroundColor = .colorCCCCCC
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let innerView = UIView().then {
        $0.backgroundColor = .colorFFFFFF
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let routineIndexLabel = UILabel().then {
        $0.text = "routine A"
        $0.textColor = .color7442FF
        $0.font = .pretendard(.regular, size: 12)
    }
    
    let routineTitleLabel = UILabel().then {
        $0.text = "오늘은 등 운동!"
        $0.textColor = .color121212
        $0.font = .pretendard(.semiBold, size: 16)
    }
    
    let editButton = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .colorF3F3F3
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor.color363636, for: .normal)
        $0.titleLabel?.font = .pretendard(.semiBold, size: 14)
        $0.isHidden = true
    }
    
    // MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         setupLayout()
         setupConstraints()
        
        innerView.backgroundColor = .white
        innerView.layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - ACTIONS
    func setupLayout() {
        self.addSubview(outerView)
        outerView.addSubviews(innerView)
        [routineIndexLabel, routineTitleLabel, editButton].forEach {
            innerView.addSubviews($0)
        }
    }
    
    func setupConstraints() {
        outerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        innerView.snp.makeConstraints {
            $0.top.leading.equalTo(outerView).offset(1)
            $0.trailing.equalTo(outerView).offset(-1)
            $0.bottom.equalTo(outerView)
        }
        
        routineIndexLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(19)
        }
        
        routineTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(19)
            $0.top.equalToSuperview().offset(30)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(65)
            $0.height.equalTo(27)
        }
    }
    
    func opendRoutine() {
        innerView.snp.remakeConstraints {
            $0.top.leading.equalTo(outerView).offset(1)
            $0.trailing.equalTo(outerView).offset(-1)
            $0.bottom.equalTo(outerView)
        }
    }
}
