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

    func apply(to oldModel: Model) -> Model {
        var model = oldModel
        switch(self) {
            case .add:
                if !model.newEntryField.isBlank() {
                    model.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                model.nextID += 1
                model.newEntryField = ""

            case .updateNewEntryField(let str):
                model.newEntryField = str

            case .check(let id, let isCompleted):
                var newEntries: [Entry] = []
                for entry in model.entries {
                    if(entry.id == id) {
                        var newEntry = entry
                        newEntry.completed = isCompleted
                        newEntries.append(newEntry)
                    } else{
                        newEntries.append(entry)
                    }
                }
                model.entries = newEntries

            case .delete(let id):
                model.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                model.entries.remove { $0.completed }
        }
        return model
    }
}
