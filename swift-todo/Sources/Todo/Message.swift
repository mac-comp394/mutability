//
//  Messages.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

enum Message {
    case add
    case updateNewEntryField(String)
    case check(Int, Bool)
    case delete(Int)
    case deleteAllCompleted

    func apply(to model: Model) -> Model {
        switch (self) {
            case .add:
                var newEntries = model.entries
                if !model.newEntryField.isBlank() {
                    newEntries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                return Model(nextID: model.nextID + 1, entries: newEntries)

            case .updateNewEntryField(let str):
                return Model(nextID: model.nextID, newEntryField: str, entries: model.entries)

            case .check(let id, let isCompleted):
                var newEntries = [Entry]()
                for entry in model.entries {
                    if entry.id == id {
                        newEntries.append(Entry(id: entry.id, description: entry.description, completed: isCompleted))
                    } else {
                        newEntries.append(Entry(id: entry.id, description: entry.description, completed: entry.completed))
                    }
                }
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: newEntries)

            case .delete(let id):
                var newEntries = model.entries
                newEntries.remove { $0.id == id }
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: newEntries)

            case .deleteAllCompleted:
                var newEntries = model.entries
                newEntries.remove { $0.completed }
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: newEntries)
        }
    }
}
