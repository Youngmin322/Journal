//
//  WriteView.swift
//  Journal
//
//  Created by 조영민 on 7/1/25.
//

import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedDate: Date = Date()

    let viewModel: JournalViewModel
    let editingEntry: JournalEntry?

    init(viewModel: JournalViewModel, editingEntry: JournalEntry? = nil) {
        self.viewModel = viewModel
        self.editingEntry = editingEntry

        if let entry = editingEntry {
            _title = State(initialValue: entry.title)
            _content = State(initialValue: entry.content)
            _selectedDate = State(initialValue: entry.date)
        }
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(.purple)
                }

                Spacer()

                Text(formatDate(selectedDate))
                    .font(.headline)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.purple)
                    }

                    Button("완료") {
                        saveJournalEntry()
                    }
                    .foregroundColor(.purple)
                    .disabled(!isFormValid)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 제목
                    ZStack(alignment: .topLeading) {
                        if title.isEmpty {
                            Text("제목")
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                        }
                        TextField("", text: $title)
                            .font(.body)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                    }
                    Divider()

                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            VStack {
                                HStack {
                                    Text("글쓰기 시작...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 12)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        TextEditor(text: $content)
                            .frame(minHeight: 300)
                            .padding(.horizontal, 4)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack(spacing: 20) {
                    Image(systemName: "textformat")
                    Image(systemName: "wand.and.stars")
                    Image(systemName: "photo")
                    Image(systemName: "camera")
                    Image(systemName: "waveform")
                    Image(systemName: "location.fill")
                    Image(systemName: "tree")
                }
                .font(.system(size: 18))
                .padding(.horizontal)
            }
        }
    }

    private func saveJournalEntry() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        if let editingEntry = editingEntry {
            viewModel.updateJournalEntry(
                editingEntry,
                title: trimmedTitle,
                content: trimmedContent,
                date: selectedDate,
                imageData: nil
            )
        } else {
            viewModel.addJournalEntry(
                title: trimmedTitle,
                content: trimmedContent,
                date: selectedDate,
                imageData: nil
            )
        }

        dismiss()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
}
