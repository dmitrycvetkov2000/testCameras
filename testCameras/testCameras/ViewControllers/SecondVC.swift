//
//  SecondVC.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 14.08.2023.
//

import UIKit

class SecondVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 20
        imageView.image = image
        
        self.navigationController?.navigationBar.isHidden = true
    }
}
