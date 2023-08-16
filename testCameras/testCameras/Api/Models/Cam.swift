//
//  Cam.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 13.08.2023.
//

import Foundation

import Foundation

// MARK: - Cam
struct Cam: Codable, Hashable {
    let success: Bool?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable, Hashable {
    let room: [String]?
    let cameras: [Camera]?
}

// MARK: - Camera
struct Camera: Codable, Hashable {
    let name: String?
    let snapshot: String?
    let room: String?
    let id: Int?
    let favorites, rec: Bool?
}
