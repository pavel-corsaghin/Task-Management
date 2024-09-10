//
//  AddOrEditTaskView.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/09.
//

import SwiftUI

struct AddOrEditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var viewModel = AddOrEditTaskViewModel()
    let editingTaskItem: TaskItem?

    var body: some View {
        VStack(alignment: .leading, content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 30,  content: {
                    TextField("Enter Name", text: $viewModel.title)
                        .padding(.horizontal)
                        .frame(height: 48)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .font(.body)
                    
                    VStack (alignment: .leading, spacing: 20, content: {
                        Text("Select Category")
                            .font(.headline)
                        
                        Picker("category", selection: $viewModel.category) {
                            Text("Personal").tag(0)
                            Text("Work").tag(1)
                            Text("Other").tag(2)
                        }
                        .pickerStyle(.segmented)
                    })
                    
                    VStack (alignment: .leading, spacing: 20, content: {
                        Text("Select Priority")
                            .font(.headline)
                        
                        Picker("priority", selection: $viewModel.priority) {
                            Text("High").tag(0)
                            Text("Medium").tag(1)
                            Text("Low").tag(2)
                        }
                        .pickerStyle(.segmented)
                    })
                    
                    HStack (alignment: .center, spacing: 20, content: {
                        Text("Due Date")
                            .font(.headline)
                        
                        DatePicker("", selection: $viewModel.dueDate, in: viewModel.dateAndTimeRange)
                            .datePickerStyle(.compact)
                        
                    })
                    
                    Toggle("Remind on Due Date", isOn: $viewModel.shouldRemind)
                        .font(.headline)
                })
                .padding(.top, 24)
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])

            Button(action: {
                saveButtonTapped()
            }, label: {
                Text("Save".uppercased())
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
            })
            .disabled(viewModel.title.isEmpty)
        })
        .navigationTitle(viewModel.isEditing ? "Edit Task" : "Add a Task")
        .onAppear {
            viewModel.setEditingTaskItem(editingTaskItem)
        }
    }
    
    func saveButtonTapped() {
        Task {
            await viewModel.saveTask()
            await MainActor.run {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddOrEditTaskView(editingTaskItem: nil)
    }
}
