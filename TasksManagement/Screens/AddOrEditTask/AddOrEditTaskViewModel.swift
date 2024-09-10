//
//  AddOrEditTaskViewModel.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI

@Observable class AddOrEditTaskViewModel {
    
    private let manager = TasksManager.shared
    
    var taskItem: TaskItem?
    var title: String = ""
    var dueDate: Date = .init()
    var category: Int = 0
    var priority: Int = 1
    var shouldRemind: Bool = false {
        didSet {
            if shouldRemind {
                registerForNotification()
            }
        }
    }
    var isEditing: Bool {
        taskItem != nil
    }
    
    var dateAndTimeRange: ClosedRange<Date> {
        getMinimumDueDate()...getMaximumDueDate()
    }

    func setEditingTaskItem(_ taskItem: TaskItem?) {
        if let taskItem {
            self.taskItem = taskItem
            title = taskItem.title
            dueDate = taskItem.dueDate
            category = taskItem.category
            priority = taskItem.priority
            shouldRemind = taskItem.shouldRemind
        } else {
            title = ""
            dueDate = getMinimumDueDate()
            category = 0
            priority = 1
            shouldRemind = false
        }
    }
    
    func saveTask() async {
        if let id = taskItem?.id {
            await manager.updateTask(
                id: id,
                title: title,
                dueDate: dueDate,
                category: category,
                priority: priority,
                shouldRemind: shouldRemind
            )
        } else {
            let task = TaskItem(
                title: title,
                dueDate: dueDate,
                category: category,
                priority: priority,
                shouldRemind: shouldRemind,
                sortOrder: manager.tasks.count
            )
            await manager.addTask(newTask: task)
        }
    }
    
    private func getMinimumDueDate() -> Date {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        components.hour = now.hour + 1
        components.minute = 0
        return  now
    }
    
    private func getMaximumDueDate() -> Date {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        components.year = now.year + 1
        components.minute = 0
        return calendar.date(from: components) ?? now
    }
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound , .alert , .badge], completionHandler: { [weak self] granted, error in
            if let error = error {
                print("Grant Permission Error: \(error)")
            }
            if !granted {
                self?.shouldRemind = false
            }
        })
    }
}
