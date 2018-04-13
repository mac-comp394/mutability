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
                var model = model
                if !model.newEntryField.isBlank() {
                    model.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                model.nextID += 1
                model.newEntryField = ""
                return model

            case .updateNewEntryField(let str):
                var model = model
                model.newEntryField = str
                return model

            case .check(let id, let isCompleted):
                var model = model
                for (index, _) in model.entries.enumerated() {
                    if(model.entries[index].id == id) {
                        model.entries[index].completed = isCompleted
                    }
                }
                return model

            case .delete(let id):
                var model = model
                model.entries.remove { $0.id == id }
                return model

            case .deleteAllCompleted:
                var model = model
                model.entries.remove { $0.completed }
                return model
        }
    }
}
