//
//  JournalViewModel.swift
//  Journal
//
//  Created by 조영민 on 7/1/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class JournalViewModel {
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
    
    // MARK: 일기 수정
    func updateJournalEntry(_ entry: JournalEntry, title: String, content: String, date: Date, imageData: Data? = nil) {
        entry.title = title
        entry.content = content
        entry.date = date
        entry.imageData = imageData
        
        do {
            try modelContext.save()
            fetchJournalEntries()
        } catch {
            print("일기 수정 실패: \(error)")
        }
    }
    
    // MARK: 검색 기능
    func searchJournalEntries(searchText: String) -> [JournalEntry] {
        if searchText.isEmpty {
            return journalEntries
        }
        
        return journalEntries.filter { entry in
            // 제목, 내용, 날짜 검색
            let titleMatch = entry.title.localizedCaseInsensitiveContains(searchText)
            let contentMatch = entry.content.localizedCaseInsensitiveContains(searchText)
            let dateMatch = searchInDate(entry.date, searchText: searchText)
            
            return titleMatch || contentMatch || dateMatch
        }
    }
    
    // MARK: 날짜 검색 헬퍼 함수
    private func searchInDate(_ date: Date, searchText: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 다양한 날짜 형식으로 검색
        let dateFormats = [
            "yyyy년 M월 d일",      // 2025년 7월 1일
            "yyyy-MM-dd",          // 2025-07-01
            "M월 d일",             // 7월 1일
            "yyyy년 M월",          // 2025년 7월
            "M월",                 // 7월
            "yyyy년",              // 2025년
            "yyyy.M.d",            // 2025.7.1
            "yy.M.d",              // 25.7.1
            "EEEE",                // 화요일
            "E"                    // 화
        ]
        
        for format in dateFormats {
            formatter.dateFormat = format
            let dateString = formatter.string(from: date)
            if dateString.localizedCaseInsensitiveContains(searchText) {
                return true
            }
        }
        
        // 숫자만으로 검색 (년도, 월, 일)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        if searchText == String(year) ||
            searchText == String(month) ||
            searchText == String(day) {
            return true
        }
        
        return false
    }
}

enum SortOrder {
    case newest
    case oldest
}
