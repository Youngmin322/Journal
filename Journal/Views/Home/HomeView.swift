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
    @State private var sortOrder: SortOrder = .newest
    @State private var showExportSheet = false
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    
    var filteredEntries: [JournalEntry] {
        guard let viewModel = viewModel else { return [] }
        let results = viewModel.searchJournalEntries(searchText: searchText)
        return sortOrder == .newest ? results.sorted(by: { $0.date > $1.date }) : results.sorted(by: { $0.date < $1.date })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showingSearch {
                    SearchBar(text: $searchText, isSearching: $showingSearch)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                
                // 일기 목록 또는 빈 상태
                if let viewModel = viewModel, !viewModel.journalEntries.isEmpty {
                    JournalListView(entries: filteredEntries, viewModel: viewModel, sortOrder: sortOrder)
                } else {
                    EmptyStateView()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("일기")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSearch.toggle()
                        if !showingSearch {
                            searchText = ""
                        }
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
                    .disabled(viewModel?.journalEntries.isEmpty ?? true)
                    .opacity(viewModel?.journalEntries.isEmpty ?? true ? 0.4 : 1)
                    
                    Menu {
                        Button("최신순") {
                            sortOrder = .newest
                        }
                        Button("오래된순") {
                            sortOrder = .oldest
                        }
                        Divider()
                        Button("PDF로 내보내기") {
                            showExportSheet = true
                        }
                    } label: {
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
            .overlay(alignment: .bottom) {
                // 플로팅 버튼
                Button(action: {
                    showWriting = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.bottom, 40)
            }
            .sheet(isPresented: $showWriting) {
                if let viewModel = viewModel {
                    WriteView(viewModel: viewModel)
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = JournalViewModel(modelContext: modelContext, journalEntries: [])
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
