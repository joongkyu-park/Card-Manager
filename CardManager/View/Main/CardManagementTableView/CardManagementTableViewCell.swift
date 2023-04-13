//
//  CardManagementTableViewCell.swift
//  CardManager
//
//  Created by Apple on 2023/02/21.
//

import UIKit

final class CardManagementTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private let menuLabel = UILabel()
    
    // MARK: - Constants
    static let identifier = "CardManagementTableViewCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCell()
        setUpMenuLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Cell
extension CardManagementTableViewCell {
    
    private func setUpCell() {
        addSubviews()
        setStyleOfCell()
    }
    
    private func addSubviews() {
        [menuLabel].forEach { addSubview($0) }
    }
    
    private func setStyleOfCell() {
        backgroundColor = .white
    }
    
}

// MARK: - Menu Label: 메뉴 이름(삭제 or 닉네임 변경)
extension CardManagementTableViewCell {
    
    private func setUpMenuLabel() {
        setStyleOfMenuLabel()
        setConstraintsOfMenuLabel()
    }
    
    private func setStyleOfMenuLabel() {
        menuLabel.backgroundColor = .clear
    }
    
    private func setConstraintsOfMenuLabel() {
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            menuLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func setContentOfMenuLabel(to menu: String) {
        menuLabel.text = menu
    }
    
}
