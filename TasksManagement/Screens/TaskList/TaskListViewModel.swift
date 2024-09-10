//
//  TaskListViewModel.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI
import Combine

@Observable class TaskListViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let manager = TasksManager.shared
    var taskItems = [TaskItem]()
    
    init() {
        manager.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.taskItems = tasks
            }
            .store(in: &cancellables)
    }
    
    func deleteItems(indexSet: IndexSet) {
        Task {
            await manager.deleteTasks(at: indexSet)
        }
    }
    
    func moveItems(from: IndexSet, to: Int) {
        Task {
            await manager.moveTasks(from: from, to: to)
        }
    }
    
    func toggleItemCompletion(id: UUID) {
        Task {
            await manager.toggleCompletion(id: id)
        }
    }
}
