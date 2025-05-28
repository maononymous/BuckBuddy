//
//  SignupView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/18/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var circleScale: CGFloat = 10
    @State private var navigate = false
    @State private var hideVStack = true
    
    var body: some View {
        
        ZStack {
            
            formView
            
            circleView
            .fullScreenCover(isPresented: $navigate) {
                LoginView(isLoggedIn: $isLoggedIn)
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
        ZStack(alignment: .bottomLeading) {
            Color.white.opacity(0)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.teal)
                .frame(width: 300, height: 300)
                .padding(.bottom, -87)
                .padding(.leading, -87)
                .scaleEffect(circleScale)
                .ignoresSafeArea()
            
            if !hideVStack {
                VStack(alignment: .leading) {
                    Text("Already a member?")
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
                        Text("Log In")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.teal)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 32)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.8)))
                    })
                }
                .padding(.bottom, 45)
                .padding(.leading, 10)
            }
        }
    }
    
    private var formView: some View {
        VStack {
            
            HStack {
                Text("Signup")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Spacer()
            }
            .padding(16)
            
            Text("BuckBuddyLogo")
                .frame(width: 250, height: 250)
            
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
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error as NSError? {
                        if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                            self.errorMessage = "Email is already in use."
                        } else {
                            self.errorMessage = error.localizedDescription
                        }
                    } else if let user = result?.user {
                        self.isLoggedIn = true
                        let uid = user.uid
                        Firestore.firestore().collection("users").document(uid).setData([
                            "name": name,
                            "email": email
                        ]) { err in
                            if let err = err {
                                print("Error saving user data: \(err.localizedDescription)")
                            } else {
                                print("User created and data saved.")
                            }
                        }
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

            Spacer()
        }
    }
}
