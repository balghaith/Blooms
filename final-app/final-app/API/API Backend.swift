//
//  API Backend.swift
//  final-app
//
//  Created by Bader Al Ghaith on 27/04/2025.
//

import Foundation


class RandomDataAPI {
    static func fetchRandomData(completion: @escaping ([RandomData]?) -> Void) {
        let url = URL(string: "https://fakerapi.it/api/v1/persons?_quantity=100")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching random data: \(error)")
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.data)
                }
            } catch {
                print("Error decoding random data: \(error)")
            }
        }.resume()
    }
}
