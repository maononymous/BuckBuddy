//
//  FriendListView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/28/25.
//
import SwiftUI

struct FriendListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var circleScale: CGFloat = 10
    @State private var circleOffset: CGSize = .zero
    @State private var circleColor: Color = .teal
    @State private var isDismissing = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Text("FriendListView")
                    .font(.largeTitle)
                Button("Go Back") {
                    animateDismiss()
                }
                .padding()
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
                        circleOffset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
                    }
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
