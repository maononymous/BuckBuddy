//
//  ProfileView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/27/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image = Image(systemName: "person.circle.fill")
    @State private var userProfile: UserProfile?
    @State private var isLoading = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var circleScale: CGFloat = 10
    @State private var circleOffset: CGSize = .zero
    @State private var circleColor: Color = .teal
    @State private var isDismissing = false
    
    var body: some View {
        ZStack {
            //Color.white.ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                HStack {
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.teal)
                    Spacer()
                }
                //Spacer()
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                
                Button("Change Profile Picture") {
                    showImagePicker = true
                }
                
                if let profile = userProfile {
                    Text(profile.name).font(.title)
                    Text(profile.email).font(.subheadline)
                }
                
                Spacer()
                
                Button("Go Back") {
                    animateDismiss()
                }
                Spacer()
            }
            .padding()
            .onAppear {
                loadUserProfile()
            }
            .sheet(isPresented: $showImagePicker, onDismiss: uploadSelectedImage) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            Circle()
                .fill(circleColor)
                .frame(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.height)
                .scaleEffect(circleScale)
                .offset(circleOffset)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        circleScale = 0.1
                        circleOffset = CGSize(width: 0, height: UIScreen.main.bounds.height)
                    }
                }
        }
    }

    private func loadUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    userProfile = try JSONDecoder().decode(UserProfile.self, from: json)
                    if let url = userProfile?.imageURL, let imageURL = URL(string: url) {
                        loadImageFromURL(imageURL)
                    }
                } catch {
                    print("Error decoding user profile: \(error)")
                }
            }
        }
    }

    private func loadImageFromURL(_ url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.selectedImage = uiImage
                }
            }
        }.resume()
    }

    private func uploadSelectedImage() {
        guard let image = selectedImage,
              let uid = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let ref = Storage.storage().reference().child("profileImages/\(uid).jpg")
        ref.putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Image upload error: \(error!.localizedDescription)")
                return
            }
            ref.downloadURL { url, _ in
                guard let url = url else { return }
                Firestore.firestore().collection("users").document(uid).updateData(["imageURL": url.absoluteString])
                loadUserProfile()
            }
        }
    }
    
    func animateDismiss() {
        guard !isDismissing else { return }
        isDismissing = true
        circleColor = .black

        withAnimation(.easeInOut(duration: 1)) {
            circleScale = 10
            circleOffset = .zero
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
    }
}
