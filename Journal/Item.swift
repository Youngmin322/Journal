//
//  Item.swift
//  Journal
//
//  Created by 조영민 on 6/30/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
