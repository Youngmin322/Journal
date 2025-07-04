//
//  DetailView.swift
//  Journal
//
//  Created by 조영민 on 7/1/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingWriteView = false
    @State private var showingDeleteAlert = false
    
    let entry: JournalEntry
    let viewModel: JournalViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 날짜
                HStack {
                    Text(formatDate(entry.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // 제목
                Text(entry.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // 내용
                Text(entry.content)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                // 이미지가 있는 경우
                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("편집") {
                        showingWriteView = true
                    }
                    
                    Button("삭제", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showingWriteView) {
            WriteView(viewModel: viewModel, editingEntry: entry)
        }
        .alert("일기 삭제", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("이 일기를 삭제하시겠습니까?")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: date)
    }
    
    private func deleteEntry() {
        viewModel.deleteJournalEntry(entry)
        dismiss()
    }
}
