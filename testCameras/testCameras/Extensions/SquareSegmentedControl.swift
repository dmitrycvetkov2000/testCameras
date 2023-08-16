//
//  SquareSegmentedControl.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 12.08.2023.
//

import UIKit

class SquareSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
    }
}
