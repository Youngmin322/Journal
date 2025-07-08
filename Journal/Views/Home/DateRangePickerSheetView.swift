//
//  DateRangePickerSheetView.swift
//  Journal
//
//  Created by 조영민 on 7/8/25.
//

import SwiftUI

struct DateRangePickerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date
    var onExport: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("시작 날짜", selection: $startDate, displayedComponents: .date)
                DatePicker("종료 날짜", selection: $endDate, displayedComponents: .date)
            }
            .navigationTitle("내보낼 범위 선택")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("내보내기") {
                        onExport()
                        dismiss()
                    }
                }
            }
        }
    }
}
