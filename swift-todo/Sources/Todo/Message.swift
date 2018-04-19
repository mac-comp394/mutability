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
        var newModel = model
        switch(self) {
            case .add:
                if !newModel.newEntryField.isBlank() {
                    newModel.entries.append(Entry(id: newModel.nextID, description: newModel.newEntryField))
                }
                newModel.nextID += 1
                newModel.newEntryField = ""

            case .updateNewEntryField(let str):
                newModel.newEntryField = str

            case .check(let id, let isCompleted):
                newModel.entries = []
                for entry in model.entries {
                    var e = entry
                    if(e.id == id) {
                        e.completed = isCompleted
                    }
                    newModel.entries.append(e)
                }
                
            case .delete(let id):
                newModel.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                newModel.entries.remove { $0.completed }
        }
        return newModel
    }
}
