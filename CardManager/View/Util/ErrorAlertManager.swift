//
//  ErrorAlertManager.swift
//  CardManager
//
//  Created by Apple on 2023/02/22.
//

import UIKit

final class ErrorAlertManager {
    
    static func alert(with error: Error) -> UIAlertController {
        var message = error.localizedDescription
        if let error = error as? NetworkError {
            message = error.description
        }
        message += "\n다시 시도해 주세요."
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
}
