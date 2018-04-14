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
        var model1 = model
        switch(self) {
            case .add:
                if !model1.newEntryField.isBlank() {
                    model1.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                return Model(nextID: model.nextID + 1, entries: model1.entries)

            case .updateNewEntryField(let str):
                model1.newEntryField = str
                return model1

            case .check(let id, let isCompleted):
                for i in 0..<(model1.entries.count){
                    if model1.entries[i].id == id{
                        let entry0 = Entry(id: model1.entries[i].id, description: model1.entries[i].description, completed: isCompleted)
                        model1.entries[i] = entry0
                    }
                }
                return model1

            case .delete(let id):
                model1.entries.remove { $0.id == id }
                return model1

            case .deleteAllCompleted:
                model1.entries.remove { $0.completed }
                return model1
        }
    }
}
