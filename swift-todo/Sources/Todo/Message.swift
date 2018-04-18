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
            var newModel = model
            if !model.newEntryField.isBlank() {
                newModel.entries.append(Entry(id: model.nextID, description: model.newEntryField))
            }
            newModel.nextID += 1
            newModel.newEntryField = ""
            return newModel
            
        case .updateNewEntryField(let str):
            var newModel = model
            newModel.newEntryField = str
            return newModel
            
        case .check(let id, let isCompleted):
            var newModel = model
            for i in model.entries.indices {
                if(model.entries[i].id == id) {
                    var newEntry = model.entries[i]
                    newEntry.completed = isCompleted
                    newModel.entries[i] = newEntry
                    break
                }
            }
            return newModel
            
        case .delete(let id):
            var newModel = model
            newModel.entries.remove { $0.id == id }
            return newModel
            
        case .deleteAllCompleted:
            var newModel = model
            newModel.entries.remove { $0.completed }
            return newModel
        }
    }
}
