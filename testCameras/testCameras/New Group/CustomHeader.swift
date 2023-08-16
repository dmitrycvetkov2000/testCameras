//
//  CustomHeader.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 13.08.2023.
//

import UIKit

class CustomHeader: UICollectionReusableView {

    @IBOutlet weak var someLabel: UILabel!
    
    static let identifier: String = "Header"
    override init(frame: CGRect) { super.init(frame: frame) }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    func createLabel(text: String) {
        someLabel.text = text
    }
}
