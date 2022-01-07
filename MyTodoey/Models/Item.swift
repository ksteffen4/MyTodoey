//
//  Item.swift
//  MyTodoey
//
//  Created by Keith Steffen on 1/7/22.
//

import Foundation

class Item: Codable {
    init(_ title: String) { self.title = title }
    init(_ title: String, _ done: Bool) {
        self.title = title
        self.done = done
    }
    let title: String
    var done = false
}

