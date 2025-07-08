//
//  JournalListView.swift
//  Journal
//
//  Created by 조영민 on 7/7/25.
//

import SwiftUI

struct JournalListView: View {
    let entries: [JournalEntry]
    let viewModel: JournalViewModel
    let sortOrder: SortOrder
    @State private var selectedEntry: JournalEntry?
    @State private var showingWriteView = false
    @State private var showingDeleteAlert = false
    @State private var entryToDelete: JournalEntry?
    
    var groupedEntries: [String: [JournalEntry]] {
        let formatter = DateFormatter()
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
                
                ForEach(Array(groupedEntries.keys.sorted(by: >)), id: \.self) { monthKey in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(monthKey)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        // 월별 일기 목록
                        let monthEntries = groupedEntries[monthKey] ?? []
                        let sortedEntries = sortOrder == .newest ?
                            monthEntries.sorted(by: { $0.date > $1.date }) :
                            monthEntries.sorted(by: { $0.date < $1.date })
                        
                        ForEach(sortedEntries, id: \.id) { entry in
                            JournalEntryRow(
                                entry: entry,
                                viewModel: viewModel,
                                onEdit: {
                                    selectedEntry = entry
                                    showingWriteView = true
                                },
                                onDelete: {
                                    entryToDelete = entry
                                    showingDeleteAlert = true
                                }
                            )
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
        .alert("일기 삭제", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) {
                entryToDelete = nil
            }
            Button("삭제", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteJournalEntry(entry)
                    entryToDelete = nil
                }
            }
        } message: {
            Text("이 일기를 삭제하시겠습니까?")
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
