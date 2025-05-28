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
    
    @State private var circleScale: CGFloat = 10
    @State private var navigate = false
    @State private var hideVStack = true
    
    var body: some View {
        
        ZStack {
            formView
            
            circleView
            .fullScreenCover(isPresented: $navigate) {
                SignupView(isLoggedIn: $isLoggedIn)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
        }
        .onAppear {
            // Reverse animation when view appears
            withAnimation(.easeInOut(duration: 0.74)) {
                circleScale = 1.0
            }
            withAnimation(.easeInOut(duration: 0.25).delay(0.74)) {
                hideVStack = false
            }
        }
        
    }
    
    private var circleView: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.white.opacity(0)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.teal)
                .frame(width: 300, height: 300)
                .padding(.bottom, -87)
                .padding(.trailing, -87)
                .scaleEffect(circleScale)
                .ignoresSafeArea()
            
            if !hideVStack {
                VStack(alignment: .trailing) {
                    Text("Don't have an account?")
                        .font(.headline)
                        .bold()
                    
                    Button(action: {
                        // Hide VStack
                        withAnimation(.easeInOut(duration: 0.25)) {
                            hideVStack = true
                        }
                        
                        // Animate circle scaling
                        withAnimation(.easeInOut(duration: 0.74).delay(0.2)) {
                            circleScale = 10
                            
                        }
                        
                        // Navigate after animation delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.94) {
                            navigate = true
                        }
                        
                    }, label: {
                        Text("Sign Up")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.teal)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 32)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.8)))
                    })
                }
                .padding(.bottom, 45)
                .padding(.trailing, 10)
            }
        }
    }
    
    private var formView: some View {
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

            Spacer()
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
