//
//  Door.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 13.08.2023.
//

import Foundation

// MARK: - Door
struct Door: Codable {
    let success: Bool?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let name: String?
    let room: String?
    let id: Int?
    let favorites: Bool?
    let snapshot: String?
}
