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
        switch(self) {
            case .add:
                var newEntries = model.entries
                var newNextID = model.nextID
                if !model.newEntryField.isBlank() {
                    newEntries.append(Entry(id: model.nextID, description: model.newEntryField))
                    newNextID += 1
                }
                return Model(nextID: newNextID, newEntryField: "", entries: newEntries)

            case .updateNewEntryField(let str):
                return Model(nextID: model.nextID, newEntryField: str, entries: model.entries)

            case .check(let id, let isCompleted):
                var newEntries = model.entries
                for entry in model.entries {
                    if(entry.id == id) {
                        let i = newEntries.index(of: entry)
                        newEntries[i!] = Entry(id: id, description: entry.description, completed: isCompleted)
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
