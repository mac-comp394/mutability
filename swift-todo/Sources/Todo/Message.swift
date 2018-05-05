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
                var entriesentriesList = model.entries
                if !model.newEntryField.isBlank() {
                    entriesList.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                return Model(nextID: model.nextID + 1, newEntryField: "", entries: entriesList)
            
            case .updateNewEntryField(let str):
                return Model(nextID:model.nextID, newEntryField: str, entries: model.entries)
            
            case .check(let id, let isCompleted):
                var entriesList = [Entry]()
				
                for entry in model.entries {
                    if(entry.id == id) {
                        entriesList.append(Entry(id: entry.id, description: entry.description, completed: isCompleted))
                    }
                }
				
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: entriesList)

            case .delete(let id):
                var entriesList = model.entries
                entriesList.remove { $0.id == id }
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: entriesList)

            case .deleteAllCompleted:
                var entriesList = model.entries
                entriesList.remove { $0.completed }
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: entriesList)
        }
    }
}

