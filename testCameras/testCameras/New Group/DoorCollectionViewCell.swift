//
//  DoorCollectionViewCell.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 13.08.2023.
//

import UIKit

class DoorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var someImage: UIImageView!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var onlineLabel: UILabel!
    static let identifier: String = "Cell2"
    
    func createImage(isHidden: Bool) {
        someImage.isHidden = isHidden
    }
    func createLabel(text: String, textOnline: String) {
        someLabel.text = text
        onlineLabel.text = textOnline
    }
    
    func createMainImage(isHidden: Bool, imageStr: String) {
        mainImage.isHidden = isHidden
        
        mainImage.contentMode = .scaleAspectFill
        mainImage.load(urlString: imageStr)
    }
}
