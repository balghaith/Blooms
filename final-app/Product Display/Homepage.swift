//
//  Homepage.swift
//  final-app
//
//  Created by Bader Al Ghaith on 25/04/2025.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var firestoreManager: FirestoreBackend
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    
    var categories = ["All", "Roses", "Sunflowers", "Tulips", "Fuchsias"]
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search produts", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onChange(of: searchText) {
                        firestoreManager.fetchProducts(for: "All", searchText: searchText)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            firestoreManager.fetchProducts(for: selectedCategory, searchText: searchText)
                        }) {
                            Text(category)
                                .padding()
                                .background(selectedCategory == category ? Color.blue : Color.gray)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(5)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .lineLimit(1)
                        }
                        }
                    }
                }
                .padding(.bottom, 10)
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(firestoreManager.products) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: CreateProductView().environmentObject(firestoreManager)) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .onAppear {
                        firestoreManager.fetchProducts(for: "All")
                        }
                    }
                }
            }
        }


#Preview {
    ProductView()
        .environmentObject(FirestoreBackend())
}
