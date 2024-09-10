//
//  TasksManager.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import Foundation
import SwiftData
import UserNotifications

class TasksManager {
    static let shared = TasksManager()
    private init() {
        Task {
            await fetchTasks()
        }
    }

    @Published var tasks: [TaskItem] = []
    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @MainActor var context: ModelContext {
        sharedModelContainer.mainContext
    }
    
    @MainActor func fetchTasks() {
        do {
            let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\.sortOrder)])
            tasks = try context.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    @MainActor func addTask(newTask: TaskItem) {
        context.insert(newTask)
        fetchTasks()
        
        if newTask.shouldRemind {
            scheduleReminderForTask(newTask)
        }
    }
    
    @MainActor func updateTask(id: UUID, title: String, dueDate: Date, category: Int, priority: Int, shouldRemind: Bool) {
        guard let task = tasks.first(where: { $0.id == id }) else { return }
        task.title = title
        task.dueDate = dueDate
        task.category = category
        task.priority = priority
        task.shouldRemind = shouldRemind
        saveContext()
        fetchTasks()
        
        if shouldRemind {
            scheduleReminderForTask(task)
        } else {
            cancelReminderForTask(task.id)
        }
    }
    
    @MainActor func toggleCompletion(id: UUID) {
        guard let task = tasks.first(where: { $0.id == id }) else { return }
        task.isCompleted.toggle()
        saveContext()
        fetchTasks()
        
        if task.isCompleted {
            cancelReminderForTask(task.id)
        } else {
            scheduleReminderForTask(task)
        }
    }
    
    @MainActor func deleteTask(at index: Int) {
        let task = tasks[index]
        context.delete(task)
        saveContext()
        fetchTasks()
        
        cancelReminderForTask(task.id)
    }
    
    @MainActor func deleteTasks(at indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            context.delete(task)
            
            cancelReminderForTask(task.id)
        }
        saveContext()
        fetchTasks()
    }
    
    @MainActor func moveTasks(from: IndexSet, to: Int) {
        tasks.move(fromOffsets: from, toOffset: to)
        for (index, task) in tasks.enumerated() {
            task.sortOrder = index
        }
        saveContext()
        fetchTasks()
    }
    
    @MainActor func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save failed")
        }
    }
    
    private func scheduleReminderForTask(_ task: TaskItem) {
        guard task.shouldRemind, task.dueDate > Date() else {
            cancelReminderForTask(task.id)
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder 📝"
        content.body = "Its time to complete the task: \(task.title)"
        content.sound = .default
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Schedule with error: \(error)")
            }
        }
    }
    
    private func cancelReminderForTask(_ taskId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId.uuidString])
    }
}
