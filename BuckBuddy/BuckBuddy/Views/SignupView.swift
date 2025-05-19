//
//  SignupView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/18/25.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Signup")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Spacer()
            }
            .padding(16)
            
            Text("BuckBuddyLogo")
                .frame(width: 300, height: 300)
            
            HStack {
                Text("Name")
                    .padding(.leading, 8)
                
                Spacer()
                
                TextField("Enter your name", text: $name)
                    .frame(width: 250, height: 35)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    .padding(.trailing,8)
            }
            
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
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        //Signup Login
                    } else {
                        errorMessage = "User Already Exists"
                    }
                }
            }) {
                Text("Signup")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 35)
                    .background(Color.black.opacity(0.87))
                    .cornerRadius(4)
            }
            .padding(6)
            
            if errorMessage == "User Already Exists" {
                Text("\(errorMessage!)")
                    .foregroundColor(.red)
                    .font(.callout)
                    .padding(.vertical, 4)
            }
            
            HStack {
                Text("Already have an account?")
                    .font(.caption)
                Button(action: {
                    dismiss()
                }) {
                    Text("Sign In")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }

            Spacer()
            
            Text("BuckBuddy © 2025 All rights reserved.")
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}
