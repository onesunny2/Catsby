//
//  ViewController+Extension.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/25/25.
//

import UIKit

extension ViewController {
    
    func viewTransition(style: ViewTransition) {
        
        switch style {
        case .push:
            navigationController?.pushViewController(self, animated: true)
        case .modal:
            present(self, animated: true)
        case .windowRoot:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            
            window.rootViewController = UINavigationController(rootViewController: self)
        }
    }
}
