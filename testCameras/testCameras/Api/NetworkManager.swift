//
//  NetworkManager.swift
//  testCameras
//
//  Created by Дмитрий Цветков on 13.08.2023.
//

import Foundation

class NetworkManager {
    func getCams(completion: @escaping (Result<Cam?, Error>) -> Void) {
        let urlString = "https://cars.cprogroup.ru/api/rubetek/cameras/"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let obj = try JSONDecoder().decode(Cam.self, from: data)
                    completion(.success(obj))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getDoors(completion: @escaping (Result<Door?, Error>) -> Void) {
        let urlString = "https://cars.cprogroup.ru/api/rubetek/doors/"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let obj = try JSONDecoder().decode(Door.self, from: data)
                    completion(.success(obj))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
