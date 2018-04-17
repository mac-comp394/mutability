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
                if !model.newEntryField.isBlank() {
                    var newEntries = model.entries
                    newEntries.append(Entry(id: model.nextID, description: model.newEntryField))
                    return Model(nextID: (model.nextID + 1), newEntryField: "", entries: newEntries)
                }
                return model

            case .updateNewEntryField(let str):
                return Model(nextID: model.nextID, newEntryField: str, entries: model.entries)

            case .check(let id, let isCompleted):
                var newEntries = model.entries
                for entry in newEntries {
                    if(entry.id == id) {
                        let i = newEntries.index(of: entry)
                        newEntries[i!] = Entry(id: id, description: entry.description, completed: isCompleted)
                        return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: newEntries)
                    }
                }
                return model

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
