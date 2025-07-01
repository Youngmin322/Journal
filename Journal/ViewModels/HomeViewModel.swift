//
//  HomeViewModel.swift
//  Journal
//
//  Created by 조영민 on 7/1/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class HomeViewModel {
    private var modelContext: ModelContext
    var journalEntries: [JournalEntry] = []
    
    init(modelContext: ModelContext, journalEntries: [JournalEntry]) {
        self.modelContext = modelContext
        fetchJournalEntries()
    }
    
    // MARK: 일기 목록 가져오기
    func fetchJournalEntries() {
        do {
            let descriptor = FetchDescriptor<JournalEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            journalEntries = try modelContext.fetch(descriptor)
        } catch {
            print("일기 목록을 가져오는데 실패함: \(error)")
        }
    }
    
    // MARK: 새 일기 추가
    func addJournalEntry(title: String, content: String, date: Date, imageData: Data? = nil) {
        let newEntry = JournalEntry(title: title, content: content, date: date, imageData: imageData)
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
            fetchJournalEntries() // 새로고침
        } catch {
            print("일기 저장 실패: \(error)")
        }
    }
    
    
}
