//
//  Date+Extensions.swift
//  TasksManagement
//
//  Created by HungNguyen on 2024/09/10.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var isInToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
}
