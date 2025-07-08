//
//  LockScreenView.swift
//  Journal
//
//  Created by 조영민 on 7/8/25.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var authVM: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Face ID로 잠금 해제")
                .font(.title2)
            
            if let error = authVM.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("잠금 해제 시도") {
                authVM.authenicate()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            authVM.authenicate()
        }
    }
}
