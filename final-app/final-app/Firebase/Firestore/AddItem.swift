//
//  AddItem.swift
//  final-app
//
//  Created by Bader Al Ghaith on 24/04/2025.
//

import SwiftUI
import PhotosUI


struct CreateProductView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var expirationDate = ""
    @State private var imageURL = ""
    @State private var selectedCategory = ""
    @EnvironmentObject var firestoreManager: FirestoreBackend
    
    let categories = ["Roses", "Sunflowers", "Tulips", "Fuchsias"]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TextField("Product Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Text("Category")
                    .font(.subheadline)
                    .bold()
                
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .lineLimit(1)
                                .fixedSize()
                                .background(selectedCategory == category ? Color.yellow : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            
            TextField("price ($)", text: $price)
                .keyboardType(.decimalPad)
                .padding()
                .font(.subheadline)
                .bold()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Text("Description")
                .font(.subheadline).bold()
            TextEditor(text: $description)
                .frame(minHeight: 160)
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Text("Expiration Days")
            TextField("e.g. 30", text: $expirationDate)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Text("Image URL")
                .font(.subheadline)
                .bold()
            
            TextField("https://example.com/image.jpg", text: $imageURL)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            
            if let url = URL(string: imageURL), !imageURL.isEmpty {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Button(action: {
                guard let priceValue = Double(price),
                      let days = Int(expirationDate) else {
                    print("Invalid price input.")
                    return
                    
                }
                
                firestoreManager.addProduct(
                    name: name,
                    description: description,
                    price: priceValue,
                    expirationDays: days,
                    category: selectedCategory,
                    imageURL: imageURL.isEmpty ? nil : imageURL
                )
                
                name = ""
                description = ""
                price = ""
                expirationDate = ""
                imageURL = ""
            }) {
                Text("Add Product")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BlueAccent"))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .padding(.top, 12)
        }
        .padding()
        .navigationTitle("New Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    CreateProductView()
        .environmentObject(FirestoreBackend())
}
