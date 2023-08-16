//
//  MItem.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 12.08.2023.
//

import UIKit

struct MItem: Hashable {
    let snapshot: String
    var name: String
    let room: String
    let favorites: Bool
    let rec: Bool
}
