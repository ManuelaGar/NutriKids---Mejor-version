//
//  File.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/10/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addImage(image: UIImage) {
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        
        var ratio: CGFloat!
        if imgSize.width > imgSize.height {
            ratio = maxSize.width/imgSize.width
        } else {
            ratio = maxSize.height/imgSize.height
        }
        
        let scaleSize = CGSize(width: imgSize.width*ratio, height: imgSize.height*ratio)
        var resizedImg = image.imageWithSize(scaleSize)
        
        if (imgSize.height > imgSize.width) {
            let left = (maxSize.width - resizedImg.size.width)/2
            resizedImg = resizedImg.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
        }
        
        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        imgAction.isEnabled = false
        imgAction.setValue(resizedImg.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}
