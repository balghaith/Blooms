//
//  Firestore Backend.swift
//  final-app
//
//  Created by Bader Al Ghaith on 24/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class FirestoreBackend: ObservableObject {
    private let db = Firestore.firestore()
    private let postsCollection = "products"
    
    @Published var products: [Product] = []
    
    func addProduct(name: String, description: String, price: Double, expirationDays: Int, category: String, imageURL: String? = nil) {
        
        let productData: [String: Any] = [
            "name": name,
            "description": description,
            "price": price,
            "expirationDays": expirationDays,
            "category": category,
            "imageURL": imageURL ?? ""
        ]
        
        db.collection(postsCollection).addDocument(data: productData) { error in
            if let error = error {
                print("Error adding product: \(error.localizedDescription)")
            } else {
                print("Product added successfully")
            }
        }
    }
    
    func deleteProduct(_ product: Product) {
        db.collection(postsCollection).document(product.id).delete { error in
            if let error = error {
                print("Failed to delete product: \(error.localizedDescription)")
            } else {
                print("Product deleted successfully")
            }
        }
    }
    
    func fetchProducts(for category: String, searchText: String = "", completion: (() -> Void)? = nil) {
        var query: Query = db.collection(postsCollection)
                
                if category != "All" {
                    query = query.whereField("category", isEqualTo: category)
                }
                if !searchText.isEmpty {
                    query = query.whereField("name", isGreaterThanOrEqualTo: searchText)
                        .whereField("name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
                }
                query.addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Error fetching products: \(error.localizedDescription)")
                        return
                    }
                            
                    
                    guard let documents = snapshot?.documents else {
                        self.products = []
                        return
                    }
                    
                    self.products = documents.compactMap { doc -> Product? in
                        let data = doc.data()
                        guard let name = data["name"] as? String,
                              let description = data["description"] as? String,
                              let price = data["price"] as? Double,
                              let expirationDays = data["expirationDays"] as? Int else {
                            return nil
                        }
                        let category = data["category"] as? String ?? "Uncategorized"
                        let imageURL = data["imageURL"] as? String
                        return Product(
                            id: doc.documentID,
                            name: name,
                            description: description,
                            price: price,
                            expirationDays: expirationDays,
                            category: category,
                            imageURL: imageURL?.isEmpty == true ? nil : imageURL
                        )
                    }
                }
            }
    }

