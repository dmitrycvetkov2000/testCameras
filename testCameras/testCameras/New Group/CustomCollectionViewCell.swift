//
//  CustomCollectionViewCell.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 12.08.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var someLabel: UILabel!
    
    @IBOutlet weak var someImage: UIImageView!
    
    @IBOutlet weak var rec: UIImageView!
    
    @IBOutlet weak var fav: UIImageView!
    
    static let identifier: String = "Cell"
    
    func createImage(imageStr: String) {
        someImage.contentMode = .scaleAspectFill
        someImage.load(urlString: imageStr)
    }
    func createLabel(text: String) {
        someLabel.text = text
    }
    func createRec(show: Bool) {
        if !show {
            rec.isHidden = true
        }
    }
    func createFav(show: Bool) {
        if !show {
            fav.isHidden = true
        }
    }
}
