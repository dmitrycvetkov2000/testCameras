//
//  SheetVC.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 14.08.2023.
//

import UIKit

class SheetVC: UIViewController {
    
    weak var secondVC: SecondVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToRoot(_ sender: Any) {
        dismiss(animated: true)
        secondVC?.navigationController?.popToRootViewController(animated: true)
    }
    
}
