//
//  Model Objects.swift
//  final-app
//
//  Created by Bader Al Ghaith on 24/04/2025.
//

import Foundation

struct Product: Identifiable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var expirationDays: Int
    var category: String
    var imageURL: String?
}

struct RandomData: Codable {
    let firstname: String
    let address: Address
}

struct Address: Codable {
    let country: String
}

struct ApiResponse: Codable {
    let status: String
    let code: Int
    let total: Int
    let data: [RandomData]
}
