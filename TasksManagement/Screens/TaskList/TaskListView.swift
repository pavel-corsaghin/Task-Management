//
//  ContentView.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI

struct TaskListView: View {
    @State var editMode: EditMode = .inactive
    @State private var viewModel = TaskListViewModel()

    var body: some View {
        ZStack {
            if viewModel.taskItems.isEmpty {
                NoTasksView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else {
                List {
                    ForEach(viewModel.taskItems) { item in
                        TaskItemView(task: item)
                            .background(
                                NavigationLink("", destination: AddOrEditTaskView(editingTaskItem: item))
                                    .opacity(0)
                            )
                            .listRowSeparator(.hidden)
                            .environment(viewModel)
                    }
                    .onDelete(perform: viewModel.deleteItems)
                    .onMove(perform: viewModel.moveItems)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Todo List 📝")
        .onChange(of: viewModel.taskItems) {_, newValue in
            if newValue.isEmpty && editMode == .active {
                editMode = .inactive
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .disabled(viewModel.taskItems.isEmpty)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddOrEditTaskView(editingTaskItem: nil)
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .environment(\.editMode, self.$editMode)
    }
}

#Preview {
    NavigationStack {
        TaskListView()
    }
}
