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

    func apply(to model: Model) ->Model{
        switch(self) {
            case .add:
                var list = model.entries
                if !model.newEntryField.isBlank() {
                    list.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                return Model(nextID: model.nextID+1, newEntryField: "", entries: list)
            
            case .updateNewEntryField(let str):
                
                return Model(nextID:model.nextID, newEntryField: str, entries: model.entries)
            
            case .check(let id, let isCompleted):
                var list = [Entry]()
                for entry in model.entries {
                    if(entry.id == id) {
                        list.append(Entry(id: entry.id, description: entry.description, completed: isCompleted))
                    }
                    else{
                        list.append(Entry(id: entry.id, description: entry.description, completed: entry.completed))
                    }
                }
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: list)

            case .delete(let id):
                var list = model.entries
                list.remove { $0.id == id }
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: list)

            case .deleteAllCompleted:
                var list = model.entries
                list.remove { $0.completed }
                return Model(nextID:model.nextID, newEntryField: model.newEntryField, entries: list)

        }
    }
}
