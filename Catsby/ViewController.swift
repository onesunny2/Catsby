//
//  ViewController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/24/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        
        NetworkManager.shared.callRequest(type: CreditMovie.self, api: .credit(movieID: 1028196)) { result in
            print(result.cast[0].profilepath)
            
        } failHandler: {
            print("실패")
        }
        


    }


}

