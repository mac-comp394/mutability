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
        
        var new_model: Model = model
        
        switch(self) {
            
            case .add:
                if !new_model.newEntryField.isBlank() {
                    new_model.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                new_model.nextID += 1
                new_model.newEntryField = ""

            case .updateNewEntryField(let str):
                new_model.newEntryField = str

            case .check(let id, let isCompleted):
                var new_entries: [Entry] = []
                
                for entry in new_model.entries {
                    if(entry.id == id) {
                        new_entries.append(Entry(id: entry.id, description: entry.description, completed: isCompleted))
                    } else {
                        new_entries.append(entry)
                    }
                }
            
                new_model.entries = new_entries

            case .delete(let id):
                new_model.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                new_model.entries.remove { $0.completed }
        }
        return new_model
    }
}
