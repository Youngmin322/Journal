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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 30/255, green: 0/255, blue: 60/255),
                    Color(red: 10/255, green: 0/255, blue: 20/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("LockColor"))
                
                Text("일기를 보려면 Face ID를 \n 사용하십시오.")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if let error = authVM.authError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button("잠금 해제") {
                    authVM.authenicate()
                }
                .buttonStyle(.borderedProminent)
            }
            .onAppear {
                authVM.authenicate()
            }
        }
    }
}

#Preview {
    LockScreenView(authVM: AuthViewModel())
}
