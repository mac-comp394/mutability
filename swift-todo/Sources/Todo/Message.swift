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

    func apply(to model: Model) -> Model{
        var newModel = model
        switch(self) {
            case .add:
                var entries = [] + model.entries
                if !model.newEntryField.isBlank() {
                    entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                newModel = Model.init(nextID: model.nextID + 1, newEntryField: "", entries: entries)

            case .updateNewEntryField(let str):
                newModel = Model.init(nextID: model.nextID, newEntryField: str, entries: model.entries)

            case .check(let id, let isCompleted):
                var entries = [] + model.entries
                for entry in model.entries {
                    if(entry.id == id) {
                        let newEntry = Entry.init(id:entry.id, description: entry.description, completed: isCompleted)
                        entries[entries.index(where: {$0.id == id})!] = newEntry
                    }
                }
                newModel = Model.init(nextID: model.nextID, newEntryField: model.newEntryField, entries: entries )

            case .delete(let id):
                var entries = [] + model.entries
                entries.remove { $0.id == id }
                newModel = Model.init(nextID: model.nextID, newEntryField: model.newEntryField, entries: entries)

            case .deleteAllCompleted:
                var entries = [] + model.entries
                entries.remove { $0.completed }
                newModel = Model.init(nextID: model.nextID, newEntryField: model.newEntryField, entries: entries)
        }
    return newModel
    }
}
