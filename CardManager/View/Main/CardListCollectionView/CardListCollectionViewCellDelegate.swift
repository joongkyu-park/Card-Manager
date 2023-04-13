//
//  CardListCollectionViewCellDelegate.swift
//  CardManager
//
//  Created by Apple on 2023/02/20.
//

import Foundation

protocol CardListCollectionViewCellDelegate: AnyObject {
    
    func cardRegistrationButtonDidTapped()
    func cardManagementButtonDidTapped()
    
}
