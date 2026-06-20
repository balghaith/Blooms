//
//  final_appApp.swift
//  final-app
//
//  Created by Bader Al Ghaith on 24/04/2025.
//

import SwiftUI
import Firebase

@main
struct final_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreManager = FirestoreBackend()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginSignUpView()
                    .environmentObject(firestoreManager)
            }
        }
    }
}
