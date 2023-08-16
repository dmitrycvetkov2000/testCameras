//
//  Cameras.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 15.08.2023.
//

import RealmSwift

class Cameras: Object {
    dynamic var items = List<Item>()
    dynamic var items2 = List<Item>()
    
    @objc dynamic var room = ""
}

class Item: Object {
    @objc dynamic var snapshot = ""
    @objc dynamic var name = ""
    @objc dynamic var room = ""
    @objc dynamic var favorites = false
    @objc dynamic var rec = false
}
