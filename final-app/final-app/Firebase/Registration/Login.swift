//
//  Login.swift
//  final-app
//
//  Created by Bader Al Ghaith on 26/04/2025.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct Registration: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ProductView()
        }
    }
}

struct LoginSignUpView: View {
    @State private var notice: String = ""
    @State private var navigate = false
    @AppStorage("user.email") private var email: String = ""
    @AppStorage("user.password") private var password: String = ""
    @State private var isError = false
    @AppStorage("isloggedin") var loggedin = false
    @EnvironmentObject var firestoreManager: FirestoreBackend

    var body: some View {
        NavigationStack {
            ZStack {
                Color("MintBackground").ignoresSafeArea()

                VStack(spacing: 15) {
                    Text("One more step to the Year 3000!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)

                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)

                    Text(notice)
                        .foregroundColor(
                            notice == "Missing Fields" || notice == "Wrong Credentials" ||
                            notice == "Account Not Registered / Invalid Credentials" ||
                            notice == "Invalid Email" || notice == "Wrong Password" ||
                            notice == "Invalid Password" || notice.starts(with: "Failed") ||
                            notice == "Email Already in Use" ? .red : .green
                        )
                        .font(.subheadline)

                    Button(action: {
                        print("Log In Tapped")

                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            if let error = error {
                                let errorCode = AuthErrorCode(rawValue: error._code)

                                switch errorCode {
                                case .wrongPassword:
                                    notice = "Wrong Password"
                                    isError = true
                                case .userNotFound:
                                    notice = "Account Not Registered"
                                    isError = true
                                case .invalidEmail:
                                    notice = "Invalid Email"
                                    isError = true
                                default:
                                    notice = "Account Not Registered / Invalid Credentials"
                                    isError = true
                                }
                            } else {
                                print("Success!")
                                notice = "Logged In!"
                                loggedin = true
                                navigate = true
                            }
                        }
                    }) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 36)
                            .background(Color("LavenderAccent"))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: NewUser()) {
                        Text("Don't Have An Account? Sign Up!")
                            .foregroundColor(.black)
                    }

                    .navigationDestination(isPresented: $navigate) {
                        ProductView()
                            .environmentObject(firestoreManager)
                    }

                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: ProductView().environmentObject(firestoreManager)) {
                                Text("Override") // for grading purposes
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct Login: View {
    @AppStorage("isloggedin") var loggedin: Bool = false

    var body: some View {
        if loggedin {
            Home()
        } else {
            LoginSignUpView()
        }
    }
}

struct Home: View {
    var body: some View {
        ProductView()
    }
}

#Preview {
    LoginSignUpView()
        .environmentObject(FirestoreBackend())
}
