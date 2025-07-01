//
//  ContentView.swift
//  Journal
//
//  Created by 조영민 on 6/30/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text("일기")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action:{ }) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        }
                        Button(action: {}) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                VStack(spacing: 25) {
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
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        //TODO: 새 일기 작성 액션
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView()
}
