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
                var new_entries = model.entries
                if !model.newEntryField.isBlank() {
                    new_entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                return Model(nextID: model.nextID + 1, entries: new_entries)

            
            case .updateNewEntryField(let str):
                return Model(nextID: model.nextID, newEntryField: str, entries: model.entries)

            
            case .check(let id, let isCompleted):
                let new_entries = model.entries.map({ (entry: Entry) -> Entry in
                    if (entry.id == id){
                        return Entry(id: entry.id, description: entry.description, completed: isCompleted)
                    }
                    else {
                        return entry
                    }
                })
                
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: new_entries)

            
            case .delete(let id):
                let new_entries = model.entries.filter({ $0.id != id })
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: new_entries)


            case .deleteAllCompleted:
                let new_entries = model.entries.filter({ !$0.completed })
                return Model(nextID: model.nextID, newEntryField: model.newEntryField, entries: new_entries)
        }
    }
}
