//
//  LoginView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/18/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var showSignUp: Bool = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack {
                    Text("Welcome to")
                        .font(.headline)
                        .padding(.trailing, 87)
                    Text("BuckBuddy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(16)
                Spacer()
            }
            
            Text("BuckBuddyLogo")
                .frame(width: 300, height: 300)
                
            HStack {
                Text("Email")
                    .padding(.leading, 8)
                
                Spacer()
                
                TextField("Enter your email", text: $email)
                    .keyboardType(.emailAddress)
                    .frame(width: 250, height: 35)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    .padding(.trailing,8)
            }
                
            HStack {
                Text("Password")
                    .padding(.leading, 8)
                
                Spacer()
                
                SecureField("Enter your password", text: $password)
                    .frame(width: 250, height: 35)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    .padding(.trailing, 8)
            }
                
            Button(action: {
                if email.isEmpty || password.isEmpty {
                    errorMessage = "Please fill in all fields."
                } else if !email.isValidEmail() {
                    errorMessage = "Please enter a valid email."
                } else {
                    errorMessage = nil
                    
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            errorMessage = nil
                            isLoggedIn = true
                        }
                    }
                    
                }
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 35)
                    .background(Color.black.opacity(0.87))
                    .cornerRadius(4)
            }
            .padding(6)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.callout)
                    .padding(.vertical, 4)
            }
            
            HStack {
                Text("Don't have an account?")
                    .font(.caption)
                Button(action: {
                    showSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .sheet(isPresented: $showSignUp) {
                    SignupView(isLoggedIn: $isLoggedIn)
                }
            }

            Spacer()
            
            Text("BuckBuddy © 2025 All rights reserved.")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}
