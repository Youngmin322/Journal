//
//  JournalEntryRow.swift
//  Journal
//
//  Created by 조영민 on 7/7/25.
//

import SwiftUI

struct JournalEntryRow: View {
    let entry: JournalEntry
    let viewModel: JournalViewModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private func formatDate(_ date: Date) -> String {
        return DateFormatter.journalFull.string(from: date)
    }
    
    private var contentPreview: String {
        let maxLength = 100
        if entry.content.count > maxLength {
            return String(entry.content.prefix(maxLength)) + "..."
        }
        return entry.content
    }
    
    var body: some View {
        NavigationLink(destination: DetailView(entry: entry, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Menu {
                        Button("편집") {
                            onEdit()
                        }
                        Button("삭제", role: .destructive) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(contentPreview)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    
                    Text(formatDate(entry.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
                Text("삭제")
            }
            
            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil")
                Text("편집")
            }
            .tint(.blue)
        }
    }
}
