//
//  Item Frame (Frontend).swift
//  final-app
//
//  Created by Bader Al Ghaith on 25/04/2025.
//

import SwiftUI
import Foundation


struct ProductCard: View {
    let product: Product
    
    @State private var randomName: String? = nil
    @State private var countryOfOrigin: String? = nil
    @State private var numberOfOthers: Int = Int.random(in: 1...99)
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                if let urlString = product.imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                                .cornerRadius(10)
                        }
                    }
                }
                Text(product.name)
                    .font(.headline)
                
                Text(product.description)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text("Price: $\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                
                Text("Category: \(product.category)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Expires in \(product.expirationDays) days")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("Recently bought by \(randomName ?? "Someone") and \(numberOfOthers >= 99 ? "99" : String(numberOfOthers)) others")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("Source of Origin: \(countryOfOrigin ?? "Unknown")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Button(action: {
                FirestoreBackend().deleteProduct(product)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
        .onAppear {
            RandomDataAPI.fetchRandomData { data in
                if let data = data, !data.isEmpty {
                    let randomPerson = data.randomElement()!
                    randomName = randomPerson.firstname.isEmpty ? "Someone" : randomPerson.firstname
                    countryOfOrigin = randomPerson.address.country.isEmpty ? "Unknown" : randomPerson.address.country
                    numberOfOthers = Int.random(in: 1...99)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProductCard(product: Product(
        id: "1",
        name: "Red Tulip",
        description: "Fresh blah blah blah",
        price: 6.50,
        expirationDays: 3,
        category: "Tulips",
        imageURL: "https://via.placeholder.com/300x200.png?text=Flower"
))
}


