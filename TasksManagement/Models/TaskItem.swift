//
//  TaskItem.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI
import SwiftData

@Model
class TaskItem: Identifiable {
    var id: UUID
    var title: String
    var dueDate: Date
    var category: Int
    var priority: Int
    var isCompleted: Bool
    var shouldRemind: Bool
    var sortOrder: Int

    init(title: String, dueDate: Date, category: Int, priority: Int, shouldRemind: Bool, sortOrder: Int) {
        self.id = .init()
        self.title = title
        self.dueDate = dueDate
        self.category = category
        self.priority = priority
        self.shouldRemind = shouldRemind
        self.isCompleted = false
        self.sortOrder = sortOrder
    }
    
    var tintColor: Color {
        return .blue
    }
}

extension TaskItem {
    static let mockItems: [TaskItem] = [
        .init(title: "Task 1", dueDate: Date(), category: 0, priority: 1, shouldRemind: true, sortOrder: 1),
    ]
}
