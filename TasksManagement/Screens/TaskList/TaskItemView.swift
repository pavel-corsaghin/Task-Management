//
//  TaskItemView.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI

struct TaskItemView: View {
    
    @Environment(TaskListViewModel.self) var viewModel
    
    let task: TaskItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 16, content: {
            Image(task.image)
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(task.title)
                HStack(alignment: .center, spacing: 4, content: {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text(formattedDate())
                        .font(.footnote)
                })
            })
            
            Spacer()
            
            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(task.isCompleted ? .green : .red)
                .onTapGesture {
                    withAnimation(.linear) {
                        viewModel.toggleItemCompletion(id: task.id)
                    }
                }
        })
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color(task.tinColor))
        .cornerRadius(12)
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        if task.dueDate.isInToday {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "d/M h:mm a"
        }
        return formatter.string(from: task.dueDate)
    }
}
#Preview {
    TaskItemView(task: TaskItem.mockItems[0])
}

private extension TaskItem {
    var image: String {
        switch category {
        case 0:
            return "work"
        case 1:
            return "personal"
        case 2:
            return "other"
        default:
            return "other"
        }
    }
    var tinColor: String {
        switch priority {
        case 0:
            return "high"
        case 1:
            return "normal"
        case 2:
            return "low"
        default:
            return "normal"
        }
    }
}
