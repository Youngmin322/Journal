//
//  StatisticsView.swift
//  Journal
//
//  Created by 조영민 on 7/2/25.
//

import SwiftUI

struct StatisticsView: View {
    let totalEntries: Int
    let totalWords: Int
    let continuousDay: Int
    
    var body: some View {
        HStack(spacing: 12) {
            StatisticCard(
                icon: "🗂️",
                title: "올해 입력 항목",
                value: "\(totalEntries)"
            )
            
            StatisticCard(
                icon: "💬",
                title: "단어 수",
                value: "\(totalWords)"
            )
            
            StatisticCard(
                icon: "📆",
                title: "일기 쓴 일수",
                value: "\(continuousDay)")
        }
    }
}

struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(icon)
                    .font(.title2)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    StatisticsView(
        totalEntries: 8,
        totalWords: 67,
        continuousDay: 1
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
