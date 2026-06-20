//
//  SignUp.swift
//  final-app
//
//  Created by Bader Al Ghaith on 26/04/2025.
//

import SwiftUI
import FirebaseAuth
import Foundation

func cleanEmail(_ email: String) -> String {
    return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

struct NewUser: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var notice: String = ""
    @State private var back = false
    @State private var isError = false
    @AppStorage("isloggedin") var loggedin = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MintBackground").ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Text("Create Your Account")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    TextField("First Name", text: $firstname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Last Name", text: $lastname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button(action: {
                        if firstname.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty {
                            notice = "Missing Fields"
                        } else if password.count < 6 {
                            notice = "Password Must Be Atleast 6 Characters"
                        } else {
                            let trimmedEmail = cleanEmail(email)
                            Auth.auth().createUser(withEmail: trimmedEmail, password: password) { result, error in
                                if let error = error {
                                    let errorCode = AuthErrorCode(rawValue: error._code)
                                    
                                    if errorCode == .emailAlreadyInUse {
                                        notice = "Email Already in Use"
                                        isError = true
                                        return
                                    } else {
                                        notice = "Failed: \(error.localizedDescription)"
                                    }
                                } else {
                                    UserDefaults.standard.set(firstname, forKey: "user.firstname")
                                    UserDefaults.standard.set(lastname, forKey: "user.lastname")
                                    UserDefaults.standard.set(email, forKey: "user.email")
                                    UserDefaults.standard.set(password, forKey: "user.password")
                                    
                                    loggedin = true
                                    notice = "Success!"
                                    isError = false
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        Text("Take me to the Year 3000!")
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 36)
                            .background(Color("LavenderAccent"))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    Text(notice)
                        .foregroundColor(isError ? .red : .green)
                        .font(.subheadline)
                    
                    // Navigation destination remains untouched
                        .navigationDestination(isPresented: $back) {
                            LoginSignUpView()
                        }
                }
                .padding()
            }
            .navigationDestination(isPresented: $back) {
                LoginSignUpView()
            }
        }
    }
}
#Preview {
    NewUser()
        .environmentObject(FirestoreBackend())
}
