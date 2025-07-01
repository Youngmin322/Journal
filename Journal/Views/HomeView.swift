//
//  ContentView.swift
//  Journal
//
//  Created by 조영민 on 6/30/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showWriting = false
    @State private var viewModel: JournalViewModel?
    @State private var searchText = ""
    @State private var showingSearch = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
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

                Button(action: {
                    showWriting = true
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
            .sheet(isPresented: $showWriting) {
                if let modelContext = try? ModelContext(ModelContainer(for: JournalEntry.self)) {
                    WriteView(viewModel: JournalViewModel(modelContext: modelContext, journalEntries: []))
                } else {
                    Text("모델 컨텍스트 생성 실패")
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("일기")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        // TODO: 검색 기능
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 32, height: 32)
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }

                    Button(action: {
                        // TODO: 더보기 기능
                    }) {
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
        }
    }
}

#Preview {
    HomeView()
}
