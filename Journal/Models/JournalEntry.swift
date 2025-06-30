//
//  Item.swift
//  Journal
//
//  Created by 조영민 on 6/30/25.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var title: String
    var content: String
    var date: Date
    var imageData: Data?

    init(title: String, content: String, date: Date = .now, imageData: Data? = nil) {
        self.title = title
        self.content = content
        self.date = date
        self.imageData = imageData
    }
}
