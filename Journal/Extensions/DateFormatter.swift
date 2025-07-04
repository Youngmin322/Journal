//
//  DateFormatter.swift
//  Journal
//
//  Created by 조영민 on 7/4/25.
//

import Foundation

extension DateFormatter {
    static let journalDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // 예: Jul 4, 2025
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 환경이면
        return formatter
    }()
    
    static let journalTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short    // 예: 오후 9:15
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let journalFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 (E)" // 예: 2025년 7월 4일 (금)
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
