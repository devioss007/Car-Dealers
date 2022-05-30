//
//  PersistenceManager.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import Foundation

enum Keys {
    static let favourites = "favourites"
    static let addedCars  = "addCars"
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    static func retrive(key: String, completion: @escaping (Result<[Car], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: key) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let favourites = try JSONDecoder().decode([Car].self, from: favoritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(error))
        }
    }
    
    static func save(key: String, items: [Car]) {
        do {
            let encodedFavorites = try JSONEncoder().encode(items)
            defaults.set(encodedFavorites, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
}
