//
//  ViewController+Extension.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/25/25.
//

import UIKit

extension UIViewController {
    
    func viewTransition(style: ViewTransition, vc: UIViewController) {
        
        switch style {
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        case .modal:
            present(vc, animated: true)
        case .windowRoot:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            
            window.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
}
