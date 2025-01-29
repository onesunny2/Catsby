//
//  DownSampling.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/29/25.
//

import UIKit
import Kingfisher

enum DownSampling {
    
    static func processor(_ imageView: UIImageView) -> DownsamplingImageProcessor {
        let processor = DownsamplingImageProcessor(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        
        return processor
    }
}
