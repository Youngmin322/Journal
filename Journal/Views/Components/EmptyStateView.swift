//
//  EmptyStateView.swift
//  Journal
//
//  Created by 조영민 on 7/7/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Spacer().frame(height: 100)
                
                Image("JournalIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(20)
                
                VStack(spacing: 12) {
                    Text("일기 쓰기 시작하기")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 4) {
                        Text("나만의 일기를 작성해 보세요.")
                        Text("시작하려면 더하기 버튼을 탭하세요.")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                }
                
                Spacer().frame(height: 300)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
    }
}
