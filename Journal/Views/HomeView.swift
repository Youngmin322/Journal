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
                    
                    Menu {
                        Button("최신순") {
                            sortOrder = .newest
                        }
                        Button("오래된순") {
                            sortOrder = .oldest
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
// MARK: - 검색바
struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("일기 검색", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Button("취소") {
                isSearching = false
                text = ""
            }
            .foregroundColor(.purple)
        }
    }
}

// MARK: - 일기 목록
struct JournalListView: View {
    let entries: [JournalEntry]
    let viewModel: JournalViewModel
    let sortOrder: SortOrder
    @State private var selectedEntry: JournalEntry?
    @State private var showingWriteView = false
    
    var groupedEntries: [String: [JournalEntry]] {
        _ = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        return Dictionary(grouping: entries) { entry in
            formatter.string(from: entry.date)
        }
    }
    // 작성된 일기 통계 계산
    var totalEntries: Int { entries.count }
    var totalWords: Int {
        entries.reduce(0) { total, entry in
            total + entry.content.count
        }
    }
    
    var continuousDay: Int {
        calculateContinuousDays()
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // 통계
                StatisticsView(
                    totalEntries: totalEntries,
                    totalWords: totalWords,
                    continuousDay: continuousDay
                )
                .padding(.horizontal)
                .padding(.top, 16)
                
                ForEach(groupedEntries.keys.sorted(by: >), id: \.self) { monthKey in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(monthKey)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        ForEach((groupedEntries[monthKey] ?? []).sorted(by: {
                            sortOrder == .newest ? $0.date > $1.date : $0.date < $1.date
                        })) { entry in
                            JournalEntryRow(entry: entry) {
                                selectedEntry = entry
                                showingWriteView = true
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // 하단 여백 (플로팅 버튼 공간)
                Spacer().frame(height: 100)
            }
            .padding(.top, 16)
        }
        .sheet(isPresented: $showingWriteView) {
            if let selectedEntry = selectedEntry {
                WriteView(viewModel: viewModel, editingEntry: selectedEntry)
            }
        }
    }
    
    // 연속 일기 작성 일수 계산
    private func calculateContinuousDays() -> Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedEntries = entries.sorted { $0.date > $1.date }
        let calendar = Calendar.current
        var continuousCount = 1
        
        for i in 0..<sortedEntries.count - 1 {
            let currentDate = calendar.startOfDay(for: sortedEntries[i].date)
            let nextDate = calendar.startOfDay(for: sortedEntries[i + 1].date)
            
            let daysDifference = calendar.dateComponents([.day], from: nextDate, to: currentDate).day ?? 0
            
            if daysDifference <= 2 { // 2일 이내
                continuousCount += 1
            } else {
                break
            }
        }
        
        return continuousCount
    }
}

// MARK: - 일기 항목 행
struct JournalEntryRow: View {
    let entry: JournalEntry
    let onTap: () -> Void
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
    
    private var contentPreview: String {
        let maxLength = 100
        if entry.content.count > maxLength {
            return String(entry.content.prefix(maxLength)) + "..."
        }
        return entry.content
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: 메뉴 액션
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                }
                
                Text(contentPreview)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(formatDate(entry.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 빈 상태 뷰
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

#Preview {
    HomeView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
