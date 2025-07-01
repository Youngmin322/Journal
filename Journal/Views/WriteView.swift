//
//  WriteView.swift
//  Journal
//
//  Created by 조영민 on 7/1/25.
//

import SwiftUI
import PhotosUI

struct WriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedDate: Date = Date()
    
    let viewModel: JournalViewModel
    let editingEntry: JournalEntry? // 편집할 일기 (nil이면 새 일기)
    
    init(viewModel: JournalViewModel, editingEntry: JournalEntry? = nil) {
        self.viewModel = viewModel
        self.editingEntry = editingEntry
        
        // 편집 모드인 경우 기존 데이터로 초기화
        if let entry = editingEntry {
            _title = State(initialValue: entry.title)
            _content = State(initialValue: entry.content)
            _selectedImageData = State(initialValue: entry.imageData)
            _selectedDate = State(initialValue: entry.date)
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 날짜 표시 (Apple 일기 앱 스타일)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(formatDate(selectedDate))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text(formatTime(selectedDate))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // 날짜 편집 버튼
                            Button(action: {
                                // 날짜 선택기 표시 로직은 나중에 추가
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    // 제목 입력
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("일기 제목을 입력하세요", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    
                    // 사진 선택
                    VStack(alignment: .leading, spacing: 8) {
                        Text("사진")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 120)
                                    .overlay(
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo")
                                                .font(.title2)
                                                .foregroundColor(.secondary)
                                            Text("사진 선택")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    )
                            }
                        }
                        .onChange(of: selectedPhoto) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                    
                    // 내용 입력
                    VStack(alignment: .leading, spacing: 8) {
                        Text("내용")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextEditor(text: $content)
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .font(.body)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(editingEntry == nil ? "새 일기" : "일기 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveJournalEntry()
                    }
                    .disabled(!isFormValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveJournalEntry() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingEntry = editingEntry {
            // 편집 모드
            viewModel.updateJournalEntry(
                editingEntry,
                title: trimmedTitle,
                content: trimmedContent,
                date: selectedDate,
                imageData: selectedImageData
            )
        } else {
            // 새 일기 작성 모드
            viewModel.addJournalEntry(
                title: trimmedTitle,
                content: trimmedContent,
                date: selectedDate,
                imageData: selectedImageData
            )
        }
        
        dismiss()
    }
    
    // MARK: - 날짜 포맷팅 함수들
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
}
